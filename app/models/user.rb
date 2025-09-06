class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
          :recoverable, :rememberable, :validatable,
          :omniauthable, omniauth_providers: [:google_oauth2]


  has_many :shops, dependent: :nullify
  has_many :favorites, dependent: :destroy
  has_many :favorite_shops, through: :favorites, source: :shop

  validates :name, presence: true, on: :create

  def bookmark(shop) # お気に入り追加 かつ 重複登録の防止
    favorite_shops << shop unless bookmark?(shop)
  end

  def unbookmark(shop)# お気に入り削除
    favorite_shops.destroy(shop)
  end

  def bookmark?(shop)# お気に入りがすでに登録されているか確認
    favorite_shops.include?(shop)
  end

  def self.from_omniauth(auth)
    user = find_by(provider: auth.provider, uid: auth.uid)

    return user if user  # 既にOAuth連携済みのユーザー

    # 2. メールアドレスで既存ユーザーを検索
    user = find_by(email: auth.info.email)

    if user  # 既存ユーザーにOAuth情報を追加
      user.update!(
        provider: auth.provider,
        uid: auth.uid)
      return user
    end

    # 3. 新規ユーザーを作成
    create!(
      email: auth.info.email,
      password: Devise.friendly_token[0, 20],
      provider: auth.provider,
      uid: auth.uid,
      name: auth.info.name
      # name: auth.info.name # 必要に応じて
    )
  end
end
