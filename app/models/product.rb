class Product < ApplicationRecord
  # Associations
  belongs_to :products_category, optional: true
  has_one :products_detail, dependent: :destroy
  has_many :order_items, dependent: :restrict_with_error

  # Validations
  validates :name, presence: true, 
                   uniqueness: true, 
                   length: { maximum: 255 }
  validates :stock, presence: true, 
                    numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :current_price, presence: true, 
                            numericality: { greater_than_or_equal_to: 0 }
  validates :original_price, presence: true, 
                             numericality: { greater_than_or_equal_to: 0 }
  validates :bulk_price, presence: true, 
                         numericality: { greater_than_or_equal_to: 0 }

  # Scopes
  scope :in_stock, -> { where('stock > 0') }
  scope :out_of_stock, -> { where(stock: 0) }
  scope :on_sale, -> { where('current_price < original_price') }
  scope :by_category, ->(category_id) { where(products_category_id: category_id) if category_id.present? }
  scope :recent, -> { where('created_at >= ?', 3.days.ago) }
  scope :recently_updated, -> { where('updated_at >= ? AND created_at < ?', 3.days.ago, 3.days.ago) }
  scope :search_by_keyword, ->(keyword) { 
    where('name LIKE ? OR quantity LIKE ?', "%#{keyword}%", "%#{keyword}%") if keyword.present? 
  }
  scope :ordered_by_name, -> { order(:name) }
  scope :ordered_by_price, -> { order(:current_price) }
  scope :ordered_by_newest, -> { order(created_at: :desc) }

  # Check if product is on sale
  def on_sale?
    current_price < original_price
  end

  # Calculate discount percentage
  def discount_percentage
    return 0 unless on_sale?
    ((original_price - current_price) / original_price * 100).round(0)
  end

  # Check if product is new (created within 3 days)
  def new_product?
    created_at >= 3.days.ago
  end

  # Check if product was recently updated (but not new)
  def recently_updated?
    updated_at >= 3.days.ago && created_at < 3.days.ago
  end

  # Check if in stock
  def in_stock?
    stock > 0
  end

  # Get category name
  def category_name
    products_category&.category_name || 'Uncategorized'
  end

  def to_s
    name
  end
end
