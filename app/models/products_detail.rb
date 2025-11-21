class ProductsDetail < ApplicationRecord
  # Associations
  belongs_to :product

  # Validations
  validates :product_id, presence: true, uniqueness: true

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "explanation", "id", "product_id", "specification", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["product"]
  end

  def description_list
    return [] unless description.present?
    description.is_a?(Array) ? description : JSON.parse(description)
  rescue JSON::ParserError
    []
  end

  def specification_hash
    return {} unless specification.present?
    specification.is_a?(Hash) ? specification : JSON.parse(specification)
  rescue JSON::ParserError
    {}
  end

  def to_s
    "Details for #{product&.name}"
  end
end
