class CartsController < ApplicationController
  def show
    @cart_items = cart_items_with_details
    @subtotal = cart_subtotal
  end

  def add
    product = Product.find_by(id: params[:product_id])

    if product&.in_stock?
      quantity = params[:quantity].present? ? params[:quantity].to_i : 1
      add_to_cart(product.id, quantity)
      flash[:notice] = "#{product.name} added to cart."
    else
      flash[:alert] = "Product not available."
    end

    redirect_back_or_to(root_path)
  end

  def update
    product_id = params[:product_id]
    quantity = params[:quantity].to_i

    if quantity.positive?
      update_cart_item(product_id, quantity)
      flash[:notice] = "Cart updated."
    else
      remove_from_cart(product_id)
      flash[:notice] = "Item removed from cart."
    end

    redirect_to cart_path
  end

  def remove
    product_id = params[:product_id]
    product = Product.find_by(id: product_id)
    remove_from_cart(product_id)

    flash[:notice] = "#{product&.name || Item} removed from cart."
    redirect_to cart_path
  end

  def clear
    clear_cart
    flash[:notice] = "Cart cleared."
    redirect_to cart_path
  end
end
