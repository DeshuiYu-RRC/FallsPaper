# app/admin/dashboard.rb
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { "Dashboard" }

  content title: proc { "Falls Paper Admin Dashboard" } do
    columns do
      column do
        panel "Recent Orders" do
          table_for Order.recent.limit(10) do
            column :order_number do |order|
              link_to order.order_number, admin_order_path(order)
            end
            column :customer_name
            column :total_amount do |order|
              number_to_currency(order.total_amount)
            end
            column :order_status
            column :created_at
          end
        end
      end

      column do
        panel "Statistics" do
          div class: "stats-container" do
            div class: "stat-box" do
              h3 "Total Products"
              para Product.count, class: "stat-number"
            end
            div class: "stat-box" do
              h3 "Total Orders"
              para Order.count, class: "stat-number"
            end
            div class: "stat-box" do
              h3 "Pending Orders"
              para Order.pending.count, class: "stat-number"
            end
            div class: "stat-box" do
              h3 "Total Users"
              para User.count, class: "stat-number"
            end
          end
        end

        panel "Categories" do
          table_for ProductsCategory.all do
            column :category_name
            column "Products" do |cat|
              cat.products.count
            end
          end
        end
      end
    end

    columns do
      column do
        panel "Low Stock Products (< 10)" do
          table_for Product.where('stock < 10').limit(10) do
            column :name do |product|
              link_to product.name.truncate(40), admin_product_path(product)
            end
            column :stock
            column :current_price do |product|
              number_to_currency(product.current_price)
            end
          end
        end
      end

      column do
        panel "Recent Users" do
          table_for User.order(created_at: :desc).limit(10) do
            column :username do |user|
              link_to user.username, admin_user_path(user)
            end
            column :email
            column :role
            column :created_at
          end
        end
      end
    end
  end
end
