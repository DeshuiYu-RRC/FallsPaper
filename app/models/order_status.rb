class OrderStatus < ApplicationRecord
  # Associations
  has_many :orders, dependent: :restrict_with_error

  # Validations
  validates :status_name, presence: true, 
                          uniqueness: true, 
                          length: { maximum: 50 }
  validates :status_order, numericality: { only_integer: true }, allow_nil: true

  # Constants for status names
  PENDING = 'pending'.freeze
  CONFIRMED = 'confirmed'.freeze
  DELIVERED = 'delivered'.freeze
  CANCELLED = 'cancelled'.freeze

  # Scopes
  scope :ordered, -> { order(:status_order) }
  scope :active, -> { where.not(status_name: CANCELLED) }

  # Class methods to get specific statuses
  def self.pending_status
    find_by(status_name: PENDING)
  end

  def self.confirmed_status
    find_by(status_name: CONFIRMED)
  end

  def self.delivered_status
    find_by(status_name: DELIVERED)
  end

  def self.cancelled_status
    find_by(status_name: CANCELLED)
  end

  def to_s
    status_name.titleize
  end
end
