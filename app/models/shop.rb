class Shop < ApplicationRecord
  geocoded_by :address
  after_validation :geocode, if: :will_save_change_to_address?

  belongs_to :user
  belongs_to :category, optional: true
  has_many :favorites, dependent: :destroy
  has_many :users, through: :favorites
  has_many_attached :images
  has_many :shop_scenes, dependent: :destroy
  has_many :scenes, through: :shop_scenes

  validates :title, presence: true
  validates :address, presence: true
  validates :category_id, presence: true
  validate :scenes_count_within_limit

  def category_name  # ★ jsにカテゴリー名を呼ぶためのこのメソッドが呼び出される
    category.present? ? category.name : 'カテゴリ未設定'
  end
  
  def scenes_name
    scenes.first ? scenes.first.name : 'シーン未設定'
    scenes.first&.name || 'シーン未設定'
  end

  def self.ransackable_attributes(auth_object = nil)
  [ "title", "address", "body", "category_id", "created_at", "latitude", "longitude", "scenes", "shop_scenes" ]
  end

  def self.ransackable_associations(auth_object = nil)
  %w[scenes shop_scenes category]
  end

  private
  def scenes_count_within_limit
    ids = Array(scene_ids).reject(&:blank?)   # hiddenフィールド対策
    if ids.size > 2
      errors.add(:scenes, "は2つまで選択できます")
    end
    # 最低1つも担保したいなら↓も併用
    # if ids.empty?
    #   errors.add(:scenes, "を1つ以上選んでください")
    # end
  end
end
