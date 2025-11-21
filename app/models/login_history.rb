class LoginHistory < ApplicationRecord
  # Associations
  belongs_to :user

  # Validations
  validates :user_id, presence: true
  validates :ip_address, length: { maximum: 45 }, allow_blank: true

  # Scopes
  scope :recent, -> { order(login_time: :desc) }
  scope :by_user, ->(user_id) { where(user_id: user_id) }

  def to_s
    "Login at #{login_time&.strftime('%Y-%m-%d %H:%M:%S')} from #{ip_address}"
  end
end
