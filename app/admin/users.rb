ActiveAdmin.register User do
  permit_params :username, :email, :password, :password_confirmation, :role_id, :is_verified

  index do
    selectable_column
    id_column
    column :username
    column :email
    column :role do |user|
      user.role&.role_name
    end
    column :is_verified
    column :created_at
    actions
  end

  filter :username
  filter :email
  filter :role
  filter :is_verified
  filter :created_at

  show do
    attributes_table do
      row :id
      row :username
      row :email
      row :role do |user|
        user.role&.role_name
      end
      row :is_verified
      row :created_at
      row :updated_at
    end
    
    panel "Orders" do
      table_for user.orders.order(created_at: :desc).limit(10) do
        column :order_number
        column :total_amount
        column :status_name
        column :created_at
        column "Actions" do |order|
          link_to "View", admin_order_path(order)
        end
      end
    end
    
    active_admin_comments
  end

  form do |f|
    f.inputs do
      f.input :username
      f.input :email
      f.input :role, as: :select, collection: Role.all.map { |r| [r.role_name, r.id] }
      f.input :is_verified
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end
end
