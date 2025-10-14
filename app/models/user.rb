class User < ApplicationRecord
  after_create :send_welcome_email

  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :omniauthable, omniauth_providers: [ :google_oauth2 ]

  has_many :shops, dependent: :nullify
  has_many :favorites, dependent: :destroy
  has_many :favorite_shops, through: :favorites, source: :shop

  validates :name, presence: true, on: :create

  # お気に入り追加 削除 重複確認
  def favorite(shop)
    favorites.find_or_create_by!(shop_id: shop.id)
  end

  def unfavorite(shop)
    favorites.where(shop_id: shop.id).destroy_all
  end

  def favorite?(shop)
    favorites.exists?(shop_id: shop.id)
  end

  private

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_row
  end
end
