# db/seeds.rb
# This file seeds the database with initial data

require 'json'

puts "Starting database seed..."

# Clear existing data (in development only)
if Rails.env.development?
  puts "Clearing existing data..."
  OrderItem.destroy_all
  Order.destroy_all
  LoginHistory.destroy_all
  User.destroy_all
  ProductsDetail.destroy_all
  Product.destroy_all
  ProductsCategory.destroy_all
  OrderStatus.destroy_all
  Province.destroy_all
  Role.destroy_all
end

# ============================================
# 1. Seed Roles
# ============================================
puts "Seeding roles..."

roles_data = [
  { role_name: 'root', role_description: 'There is only one, supreme being.' },
  { role_name: 'admin', role_description: 'Administrator with full access' },
  { role_name: 'user', role_description: 'Regular user with basic access' }
]

roles_data.each do |role_data|
  Role.find_or_create_by!(role_name: role_data[:role_name]) do |role|
    role.role_description = role_data[:role_description]
  end
end

puts "  Created #{Role.count} roles"

# ============================================
# 2. Seed Order Statuses
# ============================================
puts "Seeding order statuses..."

order_statuses_data = [
  { status_name: 'pending', status_description: 'The customer has submitted the order and is waiting for the customer service to contact and confirm.', status_order: 1 },
  { status_name: 'confirmed', status_description: 'The customer service has contacted the customer and confirmed the order details.', status_order: 2 },
  { status_name: 'delivered', status_description: 'The order completion', status_order: 3 },
  { status_name: 'cancelled', status_description: 'The order has been cancelled.', status_order: 4 }
]

order_statuses_data.each do |status_data|
  OrderStatus.find_or_create_by!(status_name: status_data[:status_name]) do |status|
    status.status_description = status_data[:status_description]
    status.status_order = status_data[:status_order]
  end
end

puts "  Created #{OrderStatus.count} order statuses"

# ============================================
# 3. Seed Canadian Provinces with Tax Rates
# ============================================
puts "Seeding provinces..."

provinces_data = [
  { code: 'AB', name: 'Alberta', gst_rate: 0.05, pst_rate: 0, hst_rate: 0 },
  { code: 'BC', name: 'British Columbia', gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0 },
  { code: 'MB', name: 'Manitoba', gst_rate: 0.05, pst_rate: 0.07, hst_rate: 0 },
  { code: 'NB', name: 'New Brunswick', gst_rate: 0, pst_rate: 0, hst_rate: 0.15 },
  { code: 'NL', name: 'Newfoundland and Labrador', gst_rate: 0, pst_rate: 0, hst_rate: 0.15 },
  { code: 'NS', name: 'Nova Scotia', gst_rate: 0, pst_rate: 0, hst_rate: 0.15 },
  { code: 'NT', name: 'Northwest Territories', gst_rate: 0.05, pst_rate: 0, hst_rate: 0 },
  { code: 'NU', name: 'Nunavut', gst_rate: 0.05, pst_rate: 0, hst_rate: 0 },
  { code: 'ON', name: 'Ontario', gst_rate: 0, pst_rate: 0, hst_rate: 0.13 },
  { code: 'PE', name: 'Prince Edward Island', gst_rate: 0, pst_rate: 0, hst_rate: 0.15 },
  { code: 'QC', name: 'Quebec', gst_rate: 0.05, pst_rate: 0.09975, hst_rate: 0 },
  { code: 'SK', name: 'Saskatchewan', gst_rate: 0.05, pst_rate: 0.06, hst_rate: 0 },
  { code: 'YT', name: 'Yukon', gst_rate: 0.05, pst_rate: 0, hst_rate: 0 }
]

provinces_data.each do |province_data|
  Province.find_or_create_by!(code: province_data[:code]) do |province|
    province.name = province_data[:name]
    province.gst_rate = province_data[:gst_rate]
    province.pst_rate = province_data[:pst_rate]
    province.hst_rate = province_data[:hst_rate]
  end
end

puts "  Created #{Province.count} provinces"

# ============================================
# 4. Seed Categories from JSON
# ============================================
puts "Seeding categories..."

categories_file = Rails.root.join('db', 'data', 'categories.json')
if File.exist?(categories_file)
  categories_json = JSON.parse(File.read(categories_file))
  categories_data = categories_json['data']

  categories_data.each do |cat|
    # Skip "All Categories" entry
    next if cat['category_id'] == -1

    ProductsCategory.find_or_create_by!(category_name: cat['category_name']) do |category|
      category.category_description = cat['category_description']
    end
  end
end

puts "  Created #{ProductsCategory.count} categories"

# ============================================
# 5. Seed Products from JSON
# ============================================
puts "Seeding products..."

products_file = Rails.root.join('db', 'data', 'products.json')
if File.exist?(products_file)
  products_json = JSON.parse(File.read(products_file))
  products_data = products_json['data']

  # Create a mapping of old category IDs to new category objects
  category_mapping = {}
  categories_json = JSON.parse(File.read(categories_file))
  categories_json['data'].each do |cat|
    next if cat['category_id'] == -1
    category = ProductsCategory.find_by(category_name: cat['category_name'])
    category_mapping[cat['category_id']] = category if category
  end

  products_data.each do |prod|
    category = category_mapping[prod['category_id']]

    Product.find_or_create_by!(name: prod['name'].strip) do |product|
      product.quantity = prod['quantity']
      product.stock = prod['stock'] || 999
      product.image = prod['image']
      product.products_category = category
      product.current_price = prod['current_price'].to_f
      product.original_price = prod['original_price'].to_f
      product.bulk_price = prod['bulk_price'].to_f
    end
  end
end

puts "  Created #{Product.count} products"

# ============================================
# 6. Seed Product Details from JSON
# ============================================
puts "Seeding product details..."

details_file = Rails.root.join('db', 'data', 'products_detail.json')
if File.exist?(details_file)
  details_json = JSON.parse(File.read(details_file))
  details_data = details_json['data']

  # Get products ordered by id to match with details
  products = Product.order(:id).to_a

  details_data.each_with_index do |detail, index|
    product = products[index]
    next unless product

    ProductsDetail.find_or_create_by!(product: product) do |pd|
      pd.explanation = detail['explanation']
      pd.description = detail['description']
      pd.specification = detail['specification']
    end
  end
end

puts "  Created #{ProductsDetail.count} product details"

# ============================================
# 7. Seed Admin User
# ============================================
puts "Seeding admin user..."

admin_role = Role.find_by(role_name: 'admin')
user_role = Role.find_by(role_name: 'user')
manitoba = Province.find_by(code: 'MB')

# Create admin user
admin = User.find_or_create_by!(email: 'admin@fallspaper.com') do |user|
  user.username = 'admin'
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = admin_role
  user.is_verified = true
  user.province = manitoba
  user.city = 'Winnipeg'
  user.address = '123 Admin Street'
  user.postal_code = 'R3C 1A1'
  user.phone = '204-555-0001'
end

# Create a test customer user
customer = User.find_or_create_by!(email: 'customer@test.com') do |user|
  user.username = 'testcustomer'
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = user_role
  user.is_verified = true
  user.province = manitoba
  user.city = 'Winnipeg'
  user.address = '456 Customer Ave'
  user.postal_code = 'R3B 2B2'
  user.phone = '204-555-0002'
end

puts "  Created #{User.count} users"

# ============================================
# 8. Seed Sample Orders (optional)
# ============================================
puts "Seeding sample orders..."

pending_status = OrderStatus.pending_status
confirmed_status = OrderStatus.confirmed_status

# Create a sample order for the test customer
if customer && Product.any?
  sample_products = Product.limit(3)
  
  order = Order.find_or_create_by!(order_number: 'ORD20250101SAMPLE') do |o|
    o.user = customer
    o.customer_name = customer.username
    o.customer_phone = customer.phone || '204-555-0002'
    o.customer_email = customer.email
    o.delivery_address = customer.address || '456 Customer Ave'
    o.delivery_city = customer.city || 'Winnipeg'
    o.delivery_postal_code = customer.postal_code || 'R3B 2B2'
    o.order_status = pending_status
    
    # Calculate totals
    subtotal = 0
    sample_products.each do |product|
      subtotal += product.current_price * 2
    end
    
    o.subtotal = subtotal
    taxes = manitoba.calculate_taxes(subtotal)
    o.tax_gst = taxes[:gst]
    o.tax_pst = taxes[:pst]
    o.tax_amount = taxes[:total]
    o.delivery_fee = 0
    o.total_amount = subtotal + taxes[:total]
  end

  # Add order items
  sample_products.each do |product|
    OrderItem.find_or_create_by!(order: order, product: product) do |item|
      item.product_name = product.name
      item.quantity = 2
      item.unit_price = product.current_price
      item.total_price = product.current_price * 2
    end
  end
end

puts "  Created #{Order.count} orders with #{OrderItem.count} items"

# ============================================
# Summary
# ============================================
puts ""
puts "=" * 50
puts "Seed completed successfully!"
puts "=" * 50
puts ""
puts "Summary:"
puts "  - Roles: #{Role.count}"
puts "  - Order Statuses: #{OrderStatus.count}"
puts "  - Provinces: #{Province.count}"
puts "  - Categories: #{ProductsCategory.count}"
puts "  - Products: #{Product.count}"
puts "  - Product Details: #{ProductsDetail.count}"
puts "  - Users: #{User.count}"
puts "  - Orders: #{Order.count}"
puts "  - Order Items: #{OrderItem.count}"
puts ""
puts "Admin Login:"
puts "  Email: admin@fallspaper.com"
puts "  Password: password123"
puts ""
puts "Test Customer Login:"
puts "  Email: customer@test.com"
puts "  Password: password123"
puts ""
