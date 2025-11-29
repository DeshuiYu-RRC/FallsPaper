class ProductsController < ApplicationController
  before_action :set_categories

  def index
    @page_title = "All Products"
    @products = Product.includes(:products_category)

    # Filter by category
    if params[:category_id].present?
      @products = @products.where(products_category_id: params[:category_id])
      @current_category = ProductsCategory.find_by(id: params[:category_id])
      @page_title = @current_category.category_name if @current_category
    end

    # Sorting
    @products = case params[:sort]
                when "price_asc"
                  @products.order(current_price: :asc)
                when "price_desc"
                  @products.order(current_price: :desc)
                when "name"
                  @products.order(name: :asc)
                else # newest
                  @products.order(created_at: :desc)
                end

    @products = @products.page(params[:page]).per(12)
  end

  def show
    @product = Product.includes(:products_detail, :products_category).find(params[:id])
    @related_products = Product.where(products_category_id: @product.products_category_id)
                               .where.not(id: @product.id)
                               .limit(4)
  end

  def search
    @page_title = "Search Results"
    @products = Product.includes(:products_category)

    @products = @products.where("name LIKE ?", "%#{params[:keyword]}%") if params[:keyword].present?

    @products = @products.where(products_category_id: params[:category_id]) if params[:category_id].present?

    @products = @products.page(params[:page]).per(12)
    render :index
  end

  def on_sale
    @page_title = "On Sale"
    @products = Product.on_sale.includes(:products_category).order(created_at: :desc).page(params[:page]).per(12)
    render :index
  end

  def new_arrivals
    @page_title = "New Arrivals (Last 3 Days)"
    @products = Product.new_arrivals.includes(:products_category).order(created_at: :desc).page(params[:page]).per(12)
    render :index
  end

  def recently_updated
    @page_title = "Recently Updated (Last 3 Days)"
    @products = Product.recently_updated.includes(:products_category).order(updated_at: :desc).page(params[:page]).per(12)
    render :index
  end

  private

  def set_categories
    @categories = ProductsCategory.order(:category_name)
  end
end
