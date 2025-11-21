# app/admin/products_categories.rb
ActiveAdmin.register ProductsCategory do
  menu priority: 3, label: "Categories"

  permit_params :category_name, :category_description

  filter :category_name
  filter :created_at

  index do
    selectable_column
    id_column
    column :category_name
    column :category_description do |cat|
      cat.category_description.to_s.truncate(50)
    end
    column "Products Count" do |cat|
      cat.products.count
    end
    column :created_at
    actions
  end

  show do
    attributes_table do
      row :id
      row :category_name
      row :category_description
      row "Products Count" do |cat|
        cat.products.count
      end
      row :created_at
      row :updated_at
    end

    panel "Products in this Category" do
      table_for products_category.products.limit(20) do
        column :name do |product|
          link_to product.name.truncate(40), admin_product_path(product)
        end
        column :current_price do |product|
          number_to_currency(product.current_price)
        end
        column :stock
      end
    end
  end

  form do |f|
    f.semantic_errors
    f.inputs "Category Information" do
      f.input :category_name
      f.input :category_description, as: :text
    end
    f.actions
  end
end
