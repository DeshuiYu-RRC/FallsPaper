class ProductsDetail < ApplicationRecord
  # Associations
  belongs_to :product

  # Validations
  validates :product_id, uniqueness: true

  # Ransack configuration
  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at description explanation id product_id specification updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["product"]
  end

  def description_list
    return [] if description.blank?

    description.is_a?(Array) ? description : JSON.parse(description)
  rescue JSON::ParserError
    []
  end

  def specification_hash
    return {} if specification.blank?

    specification.is_a?(Hash) ? specification : JSON.parse(specification)
  rescue JSON::ParserError
    {}
  end

  def to_s
    "Details for #{product&.name}"
  end
end
