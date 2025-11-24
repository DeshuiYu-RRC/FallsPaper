namespace :json do
  desc "Generate products_detail.json for 120 products"
  task generate_details: :environment do
    require "json"
    
    details = {
      "success" => true,
      "data" => []
    }
    
    # Generate details for products 1-120
    (1..120).each do |id|
      category_id = case id
      when 1..60 then 1  # Thermal
      when 61..97 then 2  # Copy
      when 98..120 then 3  # Bond/Toner/Ribbon/Drum
      else 1
      end
      
      detail = {
        "id" => id,
        "product_id" => id,
        "explanation" => get_explanation(category_id),
        "description" => get_description(category_id, id),
        "specification" => get_specification(category_id, id),
        "created_at" => "2025-09-05 15:32:21",
        "updated_at" => "2025-09-05 15:32:21"
      }
      
      details["data"] << detail
    end
    
    File.write("db/data/products_detail.json", JSON.pretty_generate(details))
    puts "Generated products_detail.json with #{details["data"].count} entries"
  end
  
  def get_explanation(category_id)
    case category_id
    when 1
      "Suitable for use with most thermal calculators, cash registers and debit machines. This Thermal Paper Rolls are 100% BPA-free to provide high-quality, crisp, dark imaging. This printing media uses lint-free premium stock to help reduces paper jams, which saves time and money."
    when 2
      "This Copy Paper delivers high-quality results time and time again. Perfect for black-and-white printing and compatible with most machines. Delivers crisp text. Each case contains 5000 sheets, making it a great option for high-volume offices."
    else
      "Experience the difference with this affordable, eco-certified paper. It delivers vibrant colors, sharp text and images, and deep blacks for professional-quality results."
    end
  end
  
  def get_description(category_id, id)
    case category_id
    when 1
      ["Provides clear and crisp images", "White Thermal POS", "BPA-Free", "For thermal POS, cash registers and debit machines", "Lint-free premium stock", "Reduces paper jams"]
    when 2
      ["8.5\" x 11\" (Letter Size)", "Ideal for black-and-white printing", "Smooth surface resists jamming", "Made in Canada", "Acid free", "SFI certified"]
    else
      ["Classic choice for presentations", "Add a touch of elegance", "FSC and Green Seal certified", "Acid and lignin free", "Perfect for laser, inkjet and copier printing"]
    end
  end
  
  def get_specification(category_id, id)
    case category_id
    when 1
      {"BPA" => "Free", "Recycled" => "NO", "Cash Register Paper Type" => "Thermal"}
    when 2
      {"BPA" => "Free", "Recycled" => "NO", "Acid Free" => "YES", "Paper Type" => "Copy Paper"}
    else
      {"BPA" => "Free", "Recycled" => "NO", "Paper Type" => "Bond Paper"}
    end
  end
end
