class Users::FindOrCreateFromOmniauth
  def self.call(auth:)
    service = Users::FindOrCreateFromOmniauth.new(auth: auth)
    user = service.call
    user
  end

  def initialize(auth:)
    @auth = auth
  end

  def call
    # Googleログイン設定
    user = User.find_by(provider: @auth.provider, uid: @auth.uid)
    return user if user

    user = User.find_by(email: @auth.info.email)
    if user
      user.update!(
        provider: @auth.provider,
        uid: @auth.uid)
      user
    end

    user = User.create!(
      email: @auth.info.email,
      password: Devise.friendly_token[0, 20],
      provider: @auth.provider,
      uid: @auth.uid,
      name: @auth.info.name
    )
    user
  end
end