class Province < ApplicationRecord
  # Associations
  has_many :users, dependent: :nullify

  # Validations
  validates :code, presence: true, 
                   uniqueness: true, 
                   length: { maximum: 2 }
  validates :name, presence: true, 
                   uniqueness: true, 
                   length: { maximum: 50 }
  validates :gst_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :pst_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }
  validates :hst_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 1 }

  # Calculate total tax rate
  def total_tax_rate
    if hst_rate > 0
      hst_rate
    else
      gst_rate + pst_rate
    end
  end

  # Calculate taxes for a given amount
  def calculate_taxes(amount)
    if hst_rate > 0
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
