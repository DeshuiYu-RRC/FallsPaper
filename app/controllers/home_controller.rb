class HomeController < ApplicationController
  def index
    @categories = ProductsCategory.all
    @featured_products = Product.limit(8)
    @on_sale_products = Product.on_sale.limit(4)
  end
end
