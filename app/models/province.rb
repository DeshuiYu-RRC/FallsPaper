class Province < ApplicationRecord
  # Associations
  has_many :users, dependent: :nullify

  # Validations
  validates :code, presence: true, uniqueness: true, length: { maximum: 2 }
  validates :name, presence: true, uniqueness: true, length: { maximum: 50 }

  # Ransack configuration
  def self.ransackable_attributes(_auth_object = nil)
    %w[code created_at gst_rate hst_rate id name pst_rate updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["users"]
  end

  # Calculate total tax rate
  def total_tax_rate
    hst_rate.positive? ? hst_rate : gst_rate + pst_rate
  end

  # Calculate taxes for a given amount
  def calculate_taxes(amount)
    if hst_rate.positive?
      { gst: 0, pst: 0, hst: (amount * hst_rate).round(2), total: (amount * hst_rate).round(2) }
    else
      gst = (amount * gst_rate).round(2)
      pst = (amount * pst_rate).round(2)
      { gst: gst, pst: pst, hst: 0, total: gst + pst }
    end
  end

  def to_s
    "#{name} (#{code})"
  end
end
