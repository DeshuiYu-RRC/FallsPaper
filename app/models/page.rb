class Page < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :content, presence: true

  def self.ransackable_attributes(_auth_object = nil)
    %w[title slug content created_at updated_at]
  end
end
