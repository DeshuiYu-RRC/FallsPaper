class OrderItem < ApplicationRecord
  # Associations
  belongs_to :order
  belongs_to :product

  # Validations
  validates :product_name, presence: true, length: { maximum: 255 }
  validates :quantity, presence: true,
                       numericality: { only_integer: true, greater_than: 0 }
  validates :unit_price, presence: true,
                         numericality: { greater_than_or_equal_to: 0 }
  validates :total_price, presence: true,
                          numericality: { greater_than_or_equal_to: 0 }

  # Callbacks
  before_validation :set_product_info, on: :create
  before_validation :calculate_total_price

  # Set product info from product
  def set_product_info
    return if product.blank?

    self.product_name ||= product.name
    self.unit_price ||= product.current_price
  end

  # Calculate total price
  def calculate_total_price
    self.total_price = (quantity.to_i * unit_price.to_f).round(2)
  end

  def to_s
    "#{quantity}x #{product_name}"
  end
end
