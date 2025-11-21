# app/admin/roles.rb
ActiveAdmin.register Role do
  menu priority: 6, label: "Roles"

  permit_params :role_name, :role_description

  filter :role_name

  index do
    selectable_column
    id_column
    column :role_name
    column :role_description
    column "Users Count" do |role|
      role.users.count
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :role_name
      row :role_description
      row "Users Count" do |role|
        role.users.count
      end
      row :created_at
      row :updated_at
    end

    panel "Users with this Role" do
      table_for role.users.limit(20) do
        column :username do |user|
          link_to user.username, admin_user_path(user)
        end
        column :email
        column :created_at
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Role Information" do
      f.input :role_name
      f.input :role_description, as: :text
    end
    f.actions
  end
end
