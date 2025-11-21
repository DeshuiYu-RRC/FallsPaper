class LoginHistory < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :user_id, presence: true

  # Scopes
  scope :recent, -> { order(login_time: :desc) }

  # Ransack configuration
  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "id", "ip_address", "login_time", "updated_at", "user_id"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["user"]
  end

  def to_s
    "Login at #{login_time&.strftime("%Y-%m-%d %H:%M:%S")} from #{ip_address}"
  end
end
