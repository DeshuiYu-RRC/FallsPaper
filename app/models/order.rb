class Order < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :order_status
  has_many :order_items, dependent: :destroy

  # Nested attributes for order items
  accepts_nested_attributes_for :order_items, allow_destroy: true

  # Validations
  validates :order_number, presence: true, uniqueness: true
  validates :customer_name, presence: true, length: { maximum: 100 }
  validates :customer_phone, presence: true, length: { maximum: 20 }
  validates :customer_email, length: { maximum: 100 }, allow_blank: true,
            format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validates :delivery_address, presence: true
  validates :delivery_city, length: { maximum: 50 }, allow_blank: true
  validates :delivery_postal_code, length: { maximum: 10 }, allow_blank: true
  validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :tax_gst, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :tax_pst, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :tax_amount, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true
  validates :delivery_fee, numericality: { greater_than_or_equal_to: 0 }, allow_nil: true

  # Callbacks
  before_validation :generate_order_number, on: :create

  # Scopes
  scope :recent, -> { order(created_at: :desc) }
  scope :by_status, ->(status_id) { where(order_status_id: status_id) if status_id.present? }
  scope :pending, -> { joins(:order_status).where(order_statuses: { status_name: OrderStatus::PENDING }) }
  scope :confirmed, -> { joins(:order_status).where(order_statuses: { status_name: OrderStatus::CONFIRMED }) }
  scope :delivered, -> { joins(:order_status).where(order_statuses: { status_name: OrderStatus::DELIVERED }) }
  scope :cancelled, -> { joins(:order_status).where(order_statuses: { status_name: OrderStatus::CANCELLED }) }

  # Generate unique order number
  def generate_order_number
    return if order_number.present?
    
    date_part = Time.current.strftime('%Y%m%d')
    random_part = SecureRandom.hex(3).upcase
    self.order_number = "ORD#{date_part}#{random_part}"
  end

  # Status helpers
  def pending?
    order_status&.status_name == OrderStatus::PENDING
  end

  def confirmed?
    order_status&.status_name == OrderStatus::CONFIRMED
  end

  def delivered?
    order_status&.status_name == OrderStatus::DELIVERED
  end

  def cancelled?
    order_status&.status_name == OrderStatus::CANCELLED
  end

  # Status transitions
  def confirm!
    return false unless pending?
    update(order_status: OrderStatus.confirmed_status, confirmed_at: Time.current)
  end

  def ship!
    return false unless confirmed?
    update(order_status: OrderStatus.delivered_status, shipped_at: Time.current)
  end

  def deliver!
    update(delivered_at: Time.current) if delivered?
  end

  def cancel!
    return false if delivered?
    update(order_status: OrderStatus.cancelled_status)
  end

  # Get full delivery address
  def full_delivery_address
    [delivery_address, delivery_city, delivery_postal_code].compact.reject(&:blank?).join(', ')
  end

  # Item count
  def item_count
    order_items.sum(:quantity)
  end

  def to_s
    order_number
  end
end
