namespace :products do
  desc "Import products from JSON file"
  task import: :environment do
    require "json"
    
    puts "=" * 60
    puts "IMPORTING PRODUCTS FROM JSON"
    puts "=" * 60
    
    # Read products.json
    products_file = Rails.root.join("db", "data", "products.json")
    unless File.exist?(products_file)
      puts "ERROR: products.json not found at #{products_file}"
      exit
    end
    
    products_data = JSON.parse(File.read(products_file))
    
    # Read products_detail.json
    details_file = Rails.root.join("db", "data", "products_detail.json")
    unless File.exist?(details_file)
      puts "ERROR: products_detail.json not found at #{details_file}"
      exit
    end
    
    details_data = JSON.parse(File.read(details_file))
    
    # Create a hash for quick lookup
    details_hash = {}
    details_data["data"].each do |detail|
      details_hash[detail["product_id"]] = detail
    end
    
    puts "Found #{products_data["data"].count} products in JSON"
    puts "-" * 60
    
    created_count = 0
    updated_count = 0
    skipped_count = 0
    
    products_data["data"].each do |product_data|
      begin
        # Find or initialize product
        product = Product.find_or_initialize_by(id: product_data["id"])
        
        # Get category by id (not category_id)
        category = ProductsCategory.find_by(id: product_data["category_id"])
        unless category
          puts "WARNING: Category #{product_data["category_id"]} not found for product #{product_data["id"]}"
          skipped_count += 1
          next
        end
        
        # Update product attributes
        product.assign_attributes(
          name: product_data["name"],
          quantity: product_data["quantity"],
          stock: product_data["stock"],
          image: product_data["image"],
          products_category: category,
          current_price: product_data["current_price"],
          original_price: product_data["original_price"],
          bulk_price: product_data["bulk_price"]
        )
        
        if product.new_record?
          product.save!
          created_count += 1
          print "+"
        else
          product.save!
          updated_count += 1
          print "."
        end
        
        # Create or update product detail
        if details_hash[product.id]
          detail_data = details_hash[product.id]
          detail = ProductsDetail.find_or_initialize_by(product_id: product.id)
          
          detail.assign_attributes(
            explanation: detail_data["explanation"],
            description: detail_data["description"],
            specification: detail_data["specification"]
          )
          
          detail.save!
        end
        
      rescue => e
        puts "\nERROR importing product #{product_data["id"]}: #{e.message}"
        skipped_count += 1
      end
    end
    
    puts "\n" + "=" * 60
    puts "IMPORT COMPLETE"
    puts "Created: #{created_count}"
    puts "Updated: #{updated_count}"
    puts "Skipped: #{skipped_count}"
    puts "Total products in database: #{Product.count}"
    puts "=" * 60
  end
end
