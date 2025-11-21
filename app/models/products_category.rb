class ProductsCategory < ApplicationRecord
  # Associations
  has_many :products, dependent: :nullify

  # Validations
  validates :category_name, presence: true, 
                            uniqueness: true, 
                            length: { maximum: 50 }

  # Scopes
  scope :with_products, -> { joins(:products).distinct }
  scope :ordered, -> { order(:category_name) }

  # Get product count for this category
  def product_count
    products.count
  end

  def to_s
    category_name
  end
end
