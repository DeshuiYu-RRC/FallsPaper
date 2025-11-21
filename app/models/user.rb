class User < ApplicationRecord
  # Devise modules
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Associations
  belongs_to :role, optional: true
  belongs_to :province, optional: true
  has_many :login_histories, dependent: :destroy
  has_many :orders, dependent: :destroy

  # Validations
  validates :username, presence: true, 
                       uniqueness: true, 
                       length: { minimum: 3, maximum: 50 }
  validates :email, presence: true, 
                    uniqueness: true,
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, length: { maximum: 20 }, allow_blank: true
  validates :postal_code, length: { maximum: 10 }, allow_blank: true

  # Scopes
  scope :verified, -> { where(is_verified: true) }
  scope :admins, -> { joins(:role).where(roles: { role_name: [Role::ADMIN, Role::ROOT] }) }
  scope :customers, -> { joins(:role).where(roles: { role_name: Role::USER }) }

  # Check if user is admin
  def admin?
    role&.admin? || false
  end

  # Get full address
  def full_address
    [address, city, province&.name, postal_code].compact.reject(&:blank?).join(", ")
  end

  # Record login
  def record_login(ip_address)
    login_histories.create(ip_address: ip_address, login_time: Time.current)
  end

  def to_s
    username
  end
end
