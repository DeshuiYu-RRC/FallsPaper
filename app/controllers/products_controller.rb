class ProductsController < ApplicationController
  before_action :set_product, only: [:show]

  def index
    @products = Product.includes(:products_category)
    
    # Filter by category
    if params[:category_id].present?
      @products = @products.by_category(params[:category_id])
      @current_category = ProductsCategory.find_by(id: params[:category_id])
    end

    # Search by keyword
    if params[:keyword].present?
      @products = @products.search_by_keyword(params[:keyword])
    end

    # Sorting
    case params[:sort]
    when "price_asc"
      @products = @products.order(current_price: :asc)
    when "price_desc"
      @products = @products.order(current_price: :desc)
    when "name"
      @products = @products.order(:name)
    when "newest"
      @products = @products.order(created_at: :desc)
    else
      @products = @products.order(created_at: :desc)
    end

    @products = @products.page(params[:page]).per(12)
    @categories = ProductsCategory.ordered
  end

  def show
    @related_products = Product.where(products_category_id: @product.products_category_id)
                               .where.not(id: @product.id)
                               .limit(4)
  end

  def search
    @keyword = params[:keyword]
    @category_id = params[:category_id]
    
    @products = Product.includes(:products_category)
    
    if @category_id.present? && @category_id != ""
      @products = @products.by_category(@category_id)
    end

    if @keyword.present?
      @products = @products.search_by_keyword(@keyword)
    end

    @products = @products.page(params[:page]).per(12)
    @categories = ProductsCategory.ordered
    
    render :index
  end

  def on_sale
    @products = Product.on_sale.includes(:products_category).page(params[:page]).per(12)
    @categories = ProductsCategory.ordered
    @page_title = "On Sale"
    render :index
  end

  def new_arrivals
    @products = Product.recent.includes(:products_category).page(params[:page]).per(12)
    @categories = ProductsCategory.ordered
    @page_title = "New Arrivals"
    render :index
  end

  def recently_updated
    @products = Product.recently_updated.includes(:products_category).page(params[:page]).per(12)
    @categories = ProductsCategory.ordered
    @page_title = "Recently Updated"
    render :index
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end
end
