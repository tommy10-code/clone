
Devise.setup do |config|
  config.mailer_sender = ENV["MAIL_FROM"] || "no-reply@example.com"

  require "devise/orm/active_record"

  config.case_insensitive_keys = [ :email ]

  config.strip_whitespace_keys = [ :email ]
  config.skip_session_storage = [ :http_auth ]

  config.stretches = Rails.env.test? ? 1 : 12

  config.reconfirmable = true

  config.expire_all_remember_me_on_sign_out = true

  config.password_length = 6..128

  config.email_regexp = /\A[^@\s]+@[^@\s]+\z/

  config.reset_password_within = 6.hours

  config.sign_out_via = :delete
  config.responder.error_status = :unprocessable_entity
  config.responder.redirect_status = :see_other

  client_id     = ENV["GOOGLE_CLIENT_ID"]
  client_secret = ENV["GOOGLE_CLIENT_SECRET"]

  # どの環境でも「値が両方あるときだけ」有効化（production限定にしたければ条件を足す）
  if client_id.present? && client_secret.present?
    config.omniauth :google_oauth2, client_id, client_secret,
                    scope: "email,profile",
                    prompt: "select_account",
                    access_type: "offline"
  else
    Rails.logger.warn "[Devise] GOOGLE_CLIENT_ID/SECRET 未設定のため Google OAuth をスキップ (env=#{Rails.env})"
  end

end
