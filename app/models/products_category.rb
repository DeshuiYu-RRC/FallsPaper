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

  # Ransack configuration
  def self.ransackable_attributes(_auth_object = nil)
    %w[category_description category_name created_at id updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["products"]
  end

  # Get product count for this category
  def product_count
    products.count
  end

  def to_s
    category_name
  end
end
