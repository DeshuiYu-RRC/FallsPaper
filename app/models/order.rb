class Order < ApplicationRecord
  # Associations
  belongs_to :user
  belongs_to :order_status, optional: true

  has_many :order_items, dependent: :destroy

  # Validations
  validates :order_number, presence: true, uniqueness: true
  validates :customer_name, presence: true
  validates :customer_phone, presence: true
  validates :customer_email, presence: true
  validates :delivery_address, presence: true
  validates :subtotal, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  # Callbacks
  before_validation :generate_order_number, on: :create

  # Ransackable attributes
  def self.ransackable_attributes(auth_object = nil)
    ["order_number", "customer_name", "customer_phone", "customer_email", 
     "total_amount", "created_at", "updated_at", "order_status_id", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user", "order_status", "order_items"]
  end

  # Status helpers
  def self.pending_status
    OrderStatus.find_by(status_name: "pending") || OrderStatus.find_by(id: 1)
  end

  def self.paid_status
    OrderStatus.find_by(status_name: "paid") || OrderStatus.find_by(id: 2)
  end

  def self.shipped_status
    OrderStatus.find_by(status_name: "shipped") || OrderStatus.find_by(id: 3)
  end

  def self.cancelled_status
    OrderStatus.find_by(status_name: "cancelled") || OrderStatus.find_by(id: 4)
  end

  def pending?
    order_status&.status_name == "pending"
  end

  def paid?
    order_status&.status_name == "paid"
  end

  def shipped?
    order_status&.status_name == "shipped"
  end

  def cancelled?
    order_status&.status_name == "cancelled"
  end

  def status_name
    order_status&.status_name || "unknown"
  end

  def status_badge_class
    case status_name
    when "pending" then "warning"
    when "paid" then "success"
    when "shipped" then "info"
    when "cancelled" then "danger"
    else "secondary"
    end
  end

  # Mark order as paid
  def mark_as_paid!(payment_intent_id)
    paid_status = Order.paid_status
    if paid_status
      update!(
        order_status_id: paid_status.id,
        stripe_payment_intent_id: payment_intent_id,
        stripe_payment_status: "succeeded",
        confirmed_at: Time.current
      )
    else
      Rails.logger.error "Paid status not found!"
    end
  end

  # Mark order as shipped
  def mark_as_shipped!
    shipped_status = Order.shipped_status
    if shipped_status
      update!(
        order_status_id: shipped_status.id,
        shipped_at: Time.current
      )
    end
  end

  private

  def generate_order_number
    self.order_number ||= "ORD#{Time.current.strftime("%Y%m%d")}#{SecureRandom.hex(4).upcase}"
  end
end
