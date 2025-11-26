class Page < ApplicationRecord
  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :content, presence: true
  
  def self.ransackable_attributes(auth_object = nil)
    ["title", "slug", "content", "created_at", "updated_at"]
  end
end
