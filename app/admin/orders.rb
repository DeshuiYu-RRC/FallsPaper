ActiveAdmin.register Order do
  permit_params :order_status_id

  index do
    selectable_column
    id_column
    column :order_number
    column :customer_name
    column :customer_email
    column "Status" do |order|
      status_tag order.status_name, class: order.status_badge_class
    end
    column :total_amount do |order|
      number_to_currency(order.total_amount)
    end
    column "Payment" do |order|
      if order.stripe_payment_intent_id.present?
        link_to "View in Stripe", "https://dashboard.stripe.com/test/payments/#{order.stripe_payment_intent_id}", target: "_blank"
      else
        "No payment"
      end
    end
    column :created_at
    actions
  end

  filter :order_number
  filter :customer_name
  filter :customer_email
  filter :order_status
  filter :created_at

  show do
    attributes_table do
      row :id
      row :order_number
      row :customer_name
      row :customer_email
      row :customer_phone
      row :delivery_address
      row :delivery_city
      row :delivery_postal_code
      row "Status" do |order|
        status_tag order.status_name, class: order.status_badge_class
      end
      row :subtotal do |order|
        number_to_currency(order.subtotal)
      end
      row :tax_gst do |order|
        number_to_currency(order.tax_gst)
      end
      row :tax_pst do |order|
        number_to_currency(order.tax_pst)
      end
      row :total_amount do |order|
        number_to_currency(order.total_amount)
      end
      row :stripe_payment_intent_id
      row :stripe_payment_status
      row :created_at
      row :confirmed_at
      row :shipped_at
    end

    panel "Order Items" do
      table_for order.order_items do
        column :product_name
        column :quantity
        column :unit_price do |item|
          number_to_currency(item.unit_price)
        end
        column :total_price do |item|
          number_to_currency(item.total_price)
        end
      end
    end

    panel "Stripe Payment" do
      if order.stripe_payment_intent_id.present?
        para link_to "View Payment in Stripe Dashboard", "https://dashboard.stripe.com/test/payments/#{order.stripe_payment_intent_id}", target: "_blank", class: "button"
      else
        para "No Stripe payment associated"
      end
    end

    active_admin_comments
  end

  form do |f|
    f.inputs "Change Order Status" do
      f.input :order_status, as: :select, collection: OrderStatus.order(:status_order).map { |s| [s.status_name.titleize, s.id] }
    end
    
    f.inputs "Order Information (Read Only)" do
      f.li "Order Number: #{f.object.order_number}"
      f.li "Customer: #{f.object.customer_name}"
      f.li "Email: #{f.object.customer_email}"
      f.li "Current Status: #{f.object.status_name.titleize}"
      f.li "Total Amount: $#{sprintf(%.2f, f.object.total_amount)}"
      
      if f.object.stripe_payment_intent_id.present?
        f.li do
          link_to "View in Stripe Dashboard", "https://dashboard.stripe.com/test/payments/#{f.object.stripe_payment_intent_id}", target: "_blank", class: "button"
        end
      end
    end
    
    f.actions
  end

  # Action to mark as shipped
  action_item :mark_shipped, only: :show, if: proc { order.paid? } do
    link_to "Mark as Shipped", mark_shipped_admin_order_path(order), method: :put, data: { confirm: "Mark this order as shipped?" }
  end

  member_action :mark_shipped, method: :put do
    order = Order.find(params[:id])
    order.mark_as_shipped!
    redirect_to admin_order_path(order), notice: "Order marked as shipped!"
  end
end
