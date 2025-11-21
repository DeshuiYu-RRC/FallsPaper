# app/admin/orders.rb
ActiveAdmin.register Order do
  menu priority: 4, label: "Orders"

  permit_params :order_number, :user_id, :customer_name, :customer_phone, :customer_email,
                :delivery_address, :delivery_city, :delivery_postal_code,
                :subtotal, :tax_gst, :tax_pst, :tax_amount, :delivery_fee, :total_amount,
                :order_status_id, :customer_notes, :admin_notes,
                order_items_attributes: [:id, :product_id, :product_name, :quantity, :unit_price, :total_price, :_destroy]

  filter :order_number
  filter :customer_name
  filter :customer_phone
  filter :order_status
  filter :user
  filter :created_at

  scope :all, default: true
  scope :pending
  scope :confirmed
  scope :delivered
  scope :cancelled

  index do
    selectable_column
    id_column
    column :order_number do |order|
      link_to order.order_number, admin_order_path(order)
    end
    column :customer_name
    column :customer_phone
    column :total_amount do |order|
      number_to_currency(order.total_amount)
    end
    column :order_status
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :order_number
      row :user
      row :customer_name
      row :customer_phone
      row :customer_email
      row "Delivery Address" do |order|
        order.full_delivery_address
      end
      row :order_status
      row :customer_notes
      row :admin_notes
    end

    panel "Order Summary" do
      attributes_table_for order do
        row :subtotal do |o|
          number_to_currency(o.subtotal)
        end
        row "GST" do |o|
          number_to_currency(o.tax_gst)
        end
        row "PST" do |o|
          number_to_currency(o.tax_pst)
        end
        row "Total Tax" do |o|
          number_to_currency(o.tax_amount)
        end
        row :delivery_fee do |o|
          number_to_currency(o.delivery_fee)
        end
        row :total_amount do |o|
          strong number_to_currency(o.total_amount)
        end
      end
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

    panel "Timeline" do
      attributes_table_for order do
        row :created_at
        row :confirmed_at
        row :shipped_at
        row :delivered_at
        row :updated_at
      end
    end

    panel "Actions" do
      div do
        if order.pending?
          span link_to "Confirm Order", confirm_admin_order_path(order), method: :put, class: "button"
          span link_to "Cancel Order", cancel_admin_order_path(order), method: :put, class: "button", data: { confirm: "Are you sure?" }
        elsif order.confirmed?
          span link_to "Mark as Shipped/Delivered", ship_admin_order_path(order), method: :put, class: "button"
          span link_to "Cancel Order", cancel_admin_order_path(order), method: :put, class: "button", data: { confirm: "Are you sure?" }
        end
      end
    end
  end

  form do |f|
    f.semantic_errors

    f.inputs "Customer Information" do
      f.input :user, as: :select, collection: User.all.map { |u| [u.username, u.id] }
      f.input :customer_name
      f.input :customer_phone
      f.input :customer_email
    end

    f.inputs "Delivery Information" do
      f.input :delivery_address
      f.input :delivery_city
      f.input :delivery_postal_code
    end

    f.inputs "Order Details" do
      f.input :order_status, as: :select, collection: OrderStatus.ordered.map { |s| [s.status_name.titleize, s.id] }
      f.input :subtotal
      f.input :tax_gst, label: "GST"
      f.input :tax_pst, label: "PST"
      f.input :tax_amount, label: "Total Tax"
      f.input :delivery_fee
      f.input :total_amount
    end

    f.inputs "Notes" do
      f.input :customer_notes, as: :text
      f.input :admin_notes, as: :text
    end

    f.inputs "Order Items" do
      f.has_many :order_items, heading: false, allow_destroy: true, new_record: "Add Item" do |item|
        item.input :product, as: :select, collection: Product.all.map { |p| [p.name.truncate(50), p.id] }
        item.input :product_name
        item.input :quantity
        item.input :unit_price
        item.input :total_price
      end
    end

    f.actions
  end

  # Custom actions for order status
  member_action :confirm, method: :put do
    if resource.confirm!
      redirect_to admin_order_path(resource), notice: "Order has been confirmed."
    else
      redirect_to admin_order_path(resource), alert: "Could not confirm order."
    end
  end

  member_action :ship, method: :put do
    if resource.ship!
      redirect_to admin_order_path(resource), notice: "Order has been marked as shipped/delivered."
    else
      redirect_to admin_order_path(resource), alert: "Could not ship order."
    end
  end

  member_action :cancel, method: :put do
    if resource.cancel!
      redirect_to admin_order_path(resource), notice: "Order has been cancelled."
    else
      redirect_to admin_order_path(resource), alert: "Could not cancel order."
    end
  end

  # Batch actions
  batch_action :confirm do |ids|
    batch_action_collection.find(ids).each do |order|
      order.confirm!
    end
    redirect_to collection_path, notice: "Orders have been confirmed."
  end

  batch_action :cancel do |ids|
    batch_action_collection.find(ids).each do |order|
      order.cancel!
    end
    redirect_to collection_path, notice: "Orders have been cancelled."
  end
end
