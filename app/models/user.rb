class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :omniauthable, omniauth_providers: [ :google_oauth2 ]


  has_many :shops, dependent: :nullify
  has_many :favorites, dependent: :destroy
  has_many :favorite_shops, through: :favorites, source: :shop

  validates :name, presence: true, on: :create

  # お気に入り追加 削除 重複確認
  def bookmark(shop)
    favorite_shops << shop unless bookmark?(shop)
  end

  def unbookmark(shop)
    favorite_shops.destroy(shop)
  end

  def bookmark?(shop)
    favorite_shops.include?(shop)
  end

  # Googleログイン設定
  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)
    return user if user
    user = find_by(email: auth.info.email)

    if user
      user.update!(
        provider: auth.provider,
        uid: auth.uid)
      return user
    end

    create!(
      email: auth.info.email,
      password: Devise.friendly_token[0, 20],
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name
    )
  end
end
