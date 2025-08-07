class Shop < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  belongs_to :category, optional: true

  def self.ransackable_attributes(auth_object = nil)
  ["title", "address", "body", "category_id", "created_at", "latitude", "longitude" ]
  end

  def self.ransackable_associations(auth_object = nil)
  []
  end
end
