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
        image_tag url_for(product.product_image.variant(:thumb)), size: "50x50"
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
      row :created_at
      row :updated_at
    end
    
    panel "Product Images - Different Sizes" do
      if product.product_image.attached?
        div do
          h3 "Uploaded Image Variants", style: "margin-bottom: 20px;"
          
          table_for [
            { name: "Thumbnail", size: "100x100px", variant: :thumb, usage: "Admin product list, small previews" },
            { name: "Small", size: "200x200px", variant: :small, usage: "Product grid cards on main site" },
            { name: "Medium", size: "400x400px", variant: :medium, usage: "Product detail pages, admin detail view" },
            { name: "Large", size: "800x800px", variant: :large, usage: "High-resolution displays, zoom features" },
            { name: "Original", size: "Full size", variant: nil, usage: "Original uploaded file (not resized)" }
          ] do
            column "Variant Name" do |img|
              strong img[:name]
            end
            column "Max Size" do |img|
              img[:size]
            end
            column "Preview" do |img|
              if img[:variant]
                image_tag url_for(product.product_image.variant(img[:variant])), 
                         style: "max-width: #{img[:size]}; border: 2px solid #ddd; padding: 5px; background: #f9f9f9;"
              else
                image_tag url_for(product.product_image), 
                         style: "max-width: 200px; border: 2px solid #ddd; padding: 5px; background: #f9f9f9;"
              end
            end
            column "Where It's Used" do |img|
              img[:usage]
            end
            column "URL Example" do |img|
              code_text = if img[:variant]
                "product.image_url(:#{img[:variant]})"
              else
                "product.image_url (no size parameter)"
              end
              code do
                code_text
              end
            end
          end
          
          div style: "margin-top: 20px; padding: 15px; background: #f0f8ff; border-left: 4px solid #0066cc;" do
            h4 "How to Use in Views:", style: "margin-top: 0;"
            ul do
              li { code "product.image_url(:thumb)" + " - For thumbnails" }
              li { code "product.image_url(:small)" + " - For product cards" }
              li { code "product.image_url(:medium)" + " - For product detail pages" }
              li { code "product.image_url(:large)" + " - For high-res displays" }
              li { code "product.image_url" + " - For original size (no parameter)" }
            end
          end
        end
      elsif product.image.present?
        div do
          h3 "URL Image (No Variants)", style: "color: #cc6600;"
          para "This product uses a URL image, not an uploaded file. Upload an image above to enable automatic resizing."
          para do
            strong "Current URL: "
            text_node product.image
          end
          image_tag product.image, style: "max-width: 400px; border: 2px solid #ddd; padding: 10px; margin-top: 10px;"
        end
      else
        div do
          para "No image uploaded yet.", style: "color: #cc0000;"
          para "Upload an image above to see automatic variants."
        end
      end
    end
    
    active_admin_comments
  end
end
