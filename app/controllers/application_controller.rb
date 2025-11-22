class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # Helper method available to views
  helper_method :current_cart, :cart_items_count

  protected

  # Authentication method for ActiveAdmin
  def authenticate_admin_user!
    authenticate_user!
    unless current_user&.admin?
      flash[:alert] = "You are not authorized to access this page."
      redirect_to root_path
    end
  end

  # Get current cart from session
  def current_cart
    session[:cart] ||= {}
    session[:cart]
  end

  # Get total items count in cart
  def cart_items_count
    current_cart.values.map(&:to_i).sum
  end

  # Add item to cart
  def add_to_cart(product_id, quantity = 1)
    session[:cart] ||= {}
    product_id = product_id.to_s
    session[:cart][product_id] ||= 0
    session[:cart][product_id] += quantity.to_i
  end

  # Update cart item quantity
  def update_cart_item(product_id, quantity)
    session[:cart] ||= {}
    product_id = product_id.to_s
    if quantity.to_i > 0
      session[:cart][product_id] = quantity.to_i
    else
      session[:cart].delete(product_id)
    end
  end

  # Remove item from cart
  def remove_from_cart(product_id)
    session[:cart] ||= {}
    session[:cart].delete(product_id.to_s)
  end

  # Clear the cart
  def clear_cart
    session[:cart] = {}
  end

  # Get cart items with product details
  def cart_items_with_details
    items = []
    return items if current_cart.nil? || current_cart.empty?
    
    current_cart.each do |product_id, quantity|
      next if quantity.to_i <= 0
      product = Product.find_by(id: product_id.to_i)
      if product
        items << {
          product: product,
          quantity: quantity.to_i,
          total: (product.current_price * quantity.to_i).round(2)
        }
      end
    end
    items
  end

  # Calculate cart subtotal
  def cart_subtotal
    cart_items_with_details.sum { |item| item[:total] }
  end
end
