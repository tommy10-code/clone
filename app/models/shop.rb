class Shop < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  belongs_to :category, optional: true
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
  has_many_attached :images
  
  has_many :shop_scenes, dependent: :destroy
  has_many :scenes, through: :shop_scenes

  def self.ransackable_attributes(auth_object = nil)
  ["title", "address", "body", "category_id", "created_at", "latitude", "longitude", "scenes", "shop_scenes" ]
  end

  def self.ransackable_associations(auth_object = nil)
  %w[scenes shop_scenes]
  end
end
