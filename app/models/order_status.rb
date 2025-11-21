class OrderStatus < ApplicationRecord
  # Associations
  has_many :orders, dependent: :restrict_with_error

  # Validations
  validates :status_name, presence: true, 
                          uniqueness: true, 
                          length: { maximum: 50 }

  # Constants
  PENDING = "pending".freeze
  CONFIRMED = "confirmed".freeze
  DELIVERED = "delivered".freeze
  CANCELLED = "cancelled".freeze

  # Scopes
  scope :ordered, -> { order(:status_order) }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "status_description", "status_name", "status_order", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["orders"]
  end

  # Class methods
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
