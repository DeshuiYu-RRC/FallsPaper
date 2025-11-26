ActiveAdmin.register Product do
  permit_params :name, :quantity, :stock, :image, :products_category_id, 
                :current_price, :original_price, :bulk_price, :product_image

  index do
    selectable_column
    id_column
    column :name
    column :category_name
    column "Image" do |product|
      if product.product_image.attached?
        image_tag url_for(product.product_image), size: "50x50"
      elsif product.image.present?
        image_tag product.image, size: "50x50"
      else
        "No image"
      end
    end
    column :current_price
    column :original_price
    column :stock
    column :created_at
    actions
  end

  filter :name
  filter :products_category
  filter :current_price
  filter :stock
  filter :created_at

  form do |f|
    f.inputs "Product Details" do
      f.input :name
      f.input :products_category, as: :select, collection: ProductsCategory.all.map { |c| [c.category_name, c.id] }
      f.input :quantity
      f.input :stock
    end
    
    f.inputs "Pricing" do
      f.input :current_price, input_html: { min: 0.01, step: 0.01 }
      f.input :original_price, input_html: { min: 0.01, step: 0.01 }
      f.input :bulk_price, input_html: { min: 0.01, step: 0.01 }
    end
    
    f.inputs "Images" do
      f.input :product_image, as: :file, hint: "Upload local image (recommended)"
      f.input :image, hint: "Or enter image URL"
      
      if f.object.product_image.attached?
        f.li "Current uploaded image:", class: "input" do
          image_tag url_for(f.object.product_image), size: "200x200"
        end
      elsif f.object.image.present?
        f.li "Current URL image:", class: "input" do
          image_tag f.object.image, size: "200x200"
        end
      end
    end
    
    f.actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :category_name
      row :quantity
      row :stock
      row :current_price
      row :original_price
      row :bulk_price
      row "Image" do |product|
        if product.product_image.attached?
          image_tag url_for(product.product_image), size: "300x300"
        elsif product.image.present?
          image_tag product.image, size: "300x300"
        else
          "No image"
        end
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
end
