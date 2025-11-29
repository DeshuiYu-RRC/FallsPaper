class Role < ApplicationRecord
  # Associations
  has_many :users, dependent: :nullify

  # Validations
  validates :role_name, presence: true, uniqueness: true, length: { maximum: 50 }

  # Constants
  ADMIN = "admin".freeze
  USER = "user".freeze
  ROOT = "root".freeze

  # Ransack configuration
  def self.ransackable_attributes(_auth_object = nil)
    %w[created_at id role_description role_name updated_at]
  end

  def self.ransackable_associations(_auth_object = nil)
    ["users"]
  end

  def admin?
    [ADMIN, ROOT].include?(role_name)
  end

  def to_s
    role_name
  end
end
