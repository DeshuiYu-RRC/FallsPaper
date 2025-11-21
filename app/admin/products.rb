# app/admin/products.rb
ActiveAdmin.register Product do
  menu priority: 2, label: "Products"

  # Permit parameters
  permit_params :name, :quantity, :stock, :image, :products_category_id,
                :current_price, :original_price, :bulk_price,
                products_detail_attributes: [:id, :explanation, :description, :specification, :_destroy]

  # Filters
  filter :name
  filter :products_category
  filter :current_price
  filter :stock
  filter :created_at

  # Scopes
  scope :all, default: true
  scope :in_stock
  scope :out_of_stock
  scope :on_sale

  # Index page
  index do
    selectable_column
    id_column
    column :name do |product|
      link_to product.name.truncate(40), admin_product_path(product)
    end
    column :category do |product|
      product.products_category&.category_name || 'N/A'
    end
    column :stock
    column :current_price do |product|
      number_to_currency(product.current_price)
    end
    column :original_price do |product|
      number_to_currency(product.original_price)
    end
    column "On Sale" do |product|
      product.on_sale? ? status_tag("Yes", class: "yes") : status_tag("No", class: "no")
    end
    column :updated_at
    actions
  end

  # Show page
  show do
    attributes_table do
      row :id
      row :name
      row :category do |product|
        product.products_category&.category_name || 'N/A'
      end
      row :quantity
      row :stock
      row :image do |product|
        if product.image.present?
          image_tag product.image, style: "max-width: 200px; max-height: 200px;"
        else
          "No image"
        end
      end
      row :current_price do |product|
        number_to_currency(product.current_price)
      end
      row :original_price do |product|
        number_to_currency(product.original_price)
      end
      row :bulk_price do |product|
        number_to_currency(product.bulk_price)
      end
      row "On Sale" do |product|
        if product.on_sale?
          "Yes - #{product.discount_percentage}% off"
        else
          "No"
        end
      end
      row :created_at
      row :updated_at
    end

    panel "Product Details" do
      if product.products_detail.present?
        attributes_table_for product.products_detail do
          row :explanation
          row :description do |detail|
            ul do
              detail.description_list.each do |item|
                li item
              end
            end
          end
          row :specification do |detail|
            table_for detail.specification_hash.to_a do
              column "Key" do |pair|
                pair[0]
              end
              column "Value" do |pair|
                pair[1]
              end
            end
          end
        end
      else
        para "No details available"
      end
    end
  end

  # Form
  form do |f|
    f.semantic_errors
    
    f.inputs "Product Information" do
      f.input :name
      f.input :products_category, as: :select, collection: ProductsCategory.all.map { |c| [c.category_name, c.id] }
      f.input :quantity
      f.input :stock
      f.input :image, hint: "Enter image URL"
    end

    f.inputs "Pricing" do
      f.input :current_price
      f.input :original_price
      f.input :bulk_price
    end

    f.inputs "Product Details", for: [:products_detail, f.object.products_detail || ProductsDetail.new] do |detail|
      detail.input :explanation, as: :text
      detail.input :description, as: :text, hint: "Enter as JSON array, e.g., [\"Item 1\", \"Item 2\"]"
      detail.input :specification, as: :text, hint: "Enter as JSON object, e.g., {\"Key\": \"Value\"}"
    end

    f.actions
  end

  # CSV export
  csv do
    column :id
    column :name
    column("Category") { |product| product.products_category&.category_name }
    column :quantity
    column :stock
    column :current_price
    column :original_price
    column :bulk_price
    column :created_at
    column :updated_at
  end
end
