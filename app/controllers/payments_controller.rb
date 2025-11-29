class PaymentsController < ApplicationController
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token, only: [:webhook]

  def create
    @cart_items = cart_items_with_details
    @subtotal = cart_subtotal

    if @cart_items.empty?
      flash.now[:alert] = "Your cart is empty."
      redirect_to cart_path and return
    end

    province = Province.find_by(id: params[:province_id])

    if province.nil?
      flash.now[:alert] = "Please select a province."
      redirect_to checkout_path and return
    end

    taxes = province.calculate_taxes(@subtotal)
    total_amount = @subtotal + taxes[:total]

    # Create the order first (pending status)
    @order = Order.new(
      user: current_user,
      customer_name: params[:customer_name],
      customer_phone: params[:customer_phone],
      customer_email: params[:customer_email],
      delivery_address: params[:delivery_address],
      delivery_city: params[:delivery_city],
      delivery_postal_code: params[:delivery_postal_code],
      subtotal: @subtotal,
      tax_gst: taxes[:gst],
      tax_pst: taxes[:pst],
      tax_amount: taxes[:total],
      delivery_fee: 0,
      total_amount: total_amount,
      order_status: OrderStatus.find_by(status_name: "pending"),
      customer_notes: params[:customer_notes]
    )

    if @order.save
      # Create order items
      @cart_items.each do |item|
        @order.order_items.create(
          product: item[:product],
          product_name: item[:product].name,
          quantity: item[:quantity],
          unit_price: item[:product].current_price,
          total_price: item[:total]
        )
      end

      # Create Stripe Payment Intent
      begin
        payment_intent = Stripe::PaymentIntent.create({
                                                        amount: (total_amount * 100).to_i, # Amount in cents
                                                        currency: "cad",
                                                        metadata: {
                                                          order_id: @order.id,
                                                          order_number: @order.order_number
                                                        },
                                                        description: "Order #{@order.order_number}"
                                                      })

        # Store payment intent ID
        @order.update(stripe_payment_intent_id: payment_intent.id)

        render json: {
          clientSecret: payment_intent.client_secret,
          order_id: @order.id
        }
      rescue Stripe::StripeError => e
        @order.destroy
        render json: { error: e.message }, status: :unprocessable_content
      end
    else
      render json: { error: @order.errors.full_messages.join(", ") }, status: :unprocessable_content
    end
  end

  def success
    @order = current_user.orders.find(params[:order_id])

    # Verify payment with Stripe
    return if @order.stripe_payment_intent_id.blank?

    begin
      payment_intent = Stripe::PaymentIntent.retrieve(@order.stripe_payment_intent_id)

      if payment_intent.status == "succeeded" && @order.pending?
        @order.mark_as_paid!(@order.stripe_payment_intent_id)
        clear_cart
      end
    rescue Stripe::StripeError => e
      Rails.logger.error "Stripe error: #{e.message}"
    end
  end

  # Stripe webhook for payment confirmation
  def webhook
    payload = request.body.read
    sig_header = request.env["HTTP_STRIPE_SIGNATURE"]
    endpoint_secret = ENV.fetch("STRIPE_WEBHOOK_SECRET", nil)

    begin
      event = Stripe::Webhook.construct_event(
        payload, sig_header, endpoint_secret
      )
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      render json: { error: "Webhook error" }, status: :bad_request and return
    end

    # Handle the event
    case event.type
    when "payment_intent.succeeded"
      payment_intent = event.data.object
      order = Order.find_by(stripe_payment_intent_id: payment_intent.id)

      order.mark_as_paid!(payment_intent.id) if order&.pending?
    when "payment_intent.payment_failed"
      payment_intent = event.data.object
      order = Order.find_by(stripe_payment_intent_id: payment_intent.id)

      order&.update(stripe_payment_status: "failed")
    end

    render json: { message: "Success" }
  end
end
