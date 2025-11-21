# app/admin/order_statuses.rb
ActiveAdmin.register OrderStatus do
  menu priority: 8, label: "Order Statuses"

  permit_params :status_name, :status_description, :status_order

  filter :status_name

  index do
    selectable_column
    id_column
    column :status_name
    column :status_description do |status|
      status.status_description.to_s.truncate(50)
    end
    column :status_order
    column "Orders Count" do |status|
      status.orders.count
    end
    actions
  end

  show do
    attributes_table do
      row :id
      row :status_name
      row :status_description
      row :status_order
      row "Orders Count" do |status|
        status.orders.count
      end
      row :created_at
      row :updated_at
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Status Information" do
      f.input :status_name
      f.input :status_description, as: :text
      f.input :status_order, as: :number, hint: "Lower numbers appear first"
    end
    f.actions
  end
end
