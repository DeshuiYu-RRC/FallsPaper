class Product < ApplicationRecord
  # Associations
  belongs_to :products_category, optional: true
  has_one :products_detail, dependent: :destroy
  has_many :order_items, dependent: :restrict_with_error
  
  # Active Storage for local image upload
  has_one_attached :product_image
  
  # Validations
  validates :name, presence: true, uniqueness: true, length: { maximum: 255 }
  validates :stock, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :current_price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :original_price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  validates :bulk_price, presence: true, numericality: { greater_than_or_equal_to: 0.01 }
  
  # Scopes
  scope :in_stock, -> { where("stock > 0") }
  scope :on_sale, -> { where("current_price < original_price") }
  scope :new_arrivals, -> { where("created_at >= ?", 3.days.ago).where.not(id: recently_updated.pluck(:id)) }
  scope :recently_updated, -> { where("updated_at >= ? AND updated_at > created_at + INTERVAL 1 HOUR", 3.days.ago) }
  
  # Ransackable attributes
  def self.ransackable_attributes(auth_object = nil)
    ["name", "current_price", "original_price", "stock", "created_at", "updated_at", "products_category_id"]
  end
  
  def self.ransackable_associations(auth_object = nil)
    ["products_category", "products_detail"]
  end
  
  # Helper methods
  def category_name
    products_category&.category_name || "Uncategorized"
  end
  
  def in_stock?
    stock > 0
  end
  
  def on_sale?
    current_price < original_price
  end
  
  def discount_percentage
    return 0 unless on_sale?
    (((original_price - current_price) / original_price) * 100).round
  end
  
  # Get image URL - prioritize uploaded image, fallback to URL
  def image_url
    if product_image.attached?
      Rails.application.routes.url_helpers.rails_blob_path(product_image, only_path: true)
    else
      image
    end
  end
end
