class CategoriesController < ApplicationController
  def index
    @categories = ProductsCategory.ordered
  end

  def show
    @category = ProductsCategory.find(params[:id])
    @products = @category.products.page(params[:page]).per(12)
  end
end
