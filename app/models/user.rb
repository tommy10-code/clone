class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable

  validates :name, presence: true
  has_many :shops, dependent: :nullify
  has_many :favorites, dependent: :destroy
  has_many :favorite_shops, through: :favorites, source: :shop

  def bookmark(shop) # お気に入り追加 かつ 重複登録の防止
    favorite_shops << shop unless bookmark?(shop)
	end

  def unbookmark(shop)# お気に入り削除
    favorite_shops.destroy(shop)
  end

  def bookmark?(shop)#お気に入りがすでに登録されているか確認
    favorite_shops.include?(shop)
  end
end
