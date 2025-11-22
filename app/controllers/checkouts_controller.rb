class CheckoutsController < ApplicationController
  before_action :authenticate_user!
  before_action :check_cart, only: [:show]

  def show
    @cart_items = cart_items_with_details
    @subtotal = cart_subtotal
    @provinces = Province.order(:name)
    
    # Pre-fill user info
    @customer_name = current_user.username
    @customer_email = current_user.email
    @customer_phone = current_user.phone
    @delivery_address = current_user.address
    @delivery_city = current_user.city
    @delivery_postal_code = current_user.postal_code
    @province = current_user.province
  end

  def create
    @cart_items = cart_items_with_details
    @subtotal = cart_subtotal
    @provinces = Province.order(:name)

    if @cart_items.empty?
      flash[:alert] = "Your cart is empty."
      redirect_to cart_path and return
    end

    province = Province.find_by(id: params[:province_id])
    
    if province.nil?
      flash[:alert] = "Please select a province."
      @customer_name = params[:customer_name]
      @customer_email = params[:customer_email]
      @customer_phone = params[:customer_phone]
      @delivery_address = params[:delivery_address]
      @delivery_city = params[:delivery_city]
      @delivery_postal_code = params[:delivery_postal_code]
      render :show and return
    end

    taxes = province.calculate_taxes(@subtotal)

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
      total_amount: @subtotal + taxes[:total],
      order_status: OrderStatus.pending_status,
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

      # Clear the cart after successful order
      clear_cart

      redirect_to checkout_success_path
    else
      flash.now[:alert] = "Error creating order: #{@order.errors.full_messages.join(", ")}"
      @customer_name = params[:customer_name]
      @customer_email = params[:customer_email]
      @customer_phone = params[:customer_phone]
      @delivery_address = params[:delivery_address]
      @delivery_city = params[:delivery_city]
      @delivery_postal_code = params[:delivery_postal_code]
      render :show
    end
  end

  def success
    @order = current_user.orders.order(created_at: :desc).first
  end

  def cancel
    redirect_to cart_path
  end

  private

  def check_cart
    if current_cart.nil? || current_cart.empty?
      flash[:alert] = "Your cart is empty."
      redirect_to products_path
    end
  end
end
