class Scene < ApplicationRecord
  has_many :shop_scenes, dependent: :destroy
  has_many :shops, through: :shop_scenes
  validates :name, presence: true, uniqueness: true
  
  def self.ransackable_attributes(_auth = nil)
  %w[id name slug created_at updated_at]
  end
end
