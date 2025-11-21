# app/admin/users.rb
ActiveAdmin.register User do
  menu priority: 5, label: "Users"

  permit_params :username, :email, :password, :password_confirmation, 
                :is_verified, :role_id, :province_id, :address, :city, 
                :postal_code, :phone

  filter :username
  filter :email
  filter :role
  filter :province
  filter :is_verified
  filter :created_at

  scope :all, default: true
  scope :verified
  scope :admins
  scope :customers

  index do
    selectable_column
    id_column
    column :username
    column :email
    column :role
    column :province do |user|
      user.province&.code
    end
    column :is_verified do |user|
      user.is_verified ? status_tag("Yes", class: "yes") : status_tag("No", class: "no")
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :username
      row :email
      row :role
      row :is_verified
      row :address
      row :city
      row :province
      row :postal_code
      row :phone
      row "Full Address" do |user|
        user.full_address
      end
      row :created_at
      row :updated_at
    end

    panel "Orders" do
      table_for user.orders.recent.limit(10) do
        column :order_number do |order|
          link_to order.order_number, admin_order_path(order)
        end
        column :total_amount do |order|
          number_to_currency(order.total_amount)
        end
        column :order_status
        column :created_at
      end
    end

    panel "Login History" do
      table_for user.login_histories.recent.limit(10) do
        column :ip_address
        column :login_time
      end
    end
  end

  form do |f|
    f.semantic_errors
    
    f.inputs "Account Information" do
      f.input :username
      f.input :email
      f.input :password, hint: "Leave blank to keep current password"
      f.input :password_confirmation
      f.input :role, as: :select, collection: Role.all.map { |r| [r.role_name, r.id] }
      f.input :is_verified
    end

    f.inputs "Address Information" do
      f.input :address
      f.input :city
      f.input :province, as: :select, collection: Province.all.map { |p| [p.name, p.id] }
      f.input :postal_code
      f.input :phone
    end

    f.actions
  end

  controller do
    def update
      if params[:user][:password].blank? && params[:user][:password_confirmation].blank?
        params[:user].delete(:password)
        params[:user].delete(:password_confirmation)
      end
      super
    end
  end
end
