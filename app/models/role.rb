class Role < ApplicationRecord
  # Associations
  has_many :users, dependent: :nullify

  # Validations
  validates :role_name, presence: true, 
                        uniqueness: true, 
                        length: { maximum: 50 }

  # Constants for role names
  ADMIN = 'admin'.freeze
  USER = 'user'.freeze
  ROOT = 'root'.freeze

  # Scopes
  scope :admin_role, -> { find_by(role_name: ADMIN) }
  scope :user_role, -> { find_by(role_name: USER) }

  def admin?
    role_name == ADMIN || role_name == ROOT
  end

  def to_s
    role_name
  end
end
