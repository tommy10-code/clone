class MailTestController < ApplicationController
  def send_mail
    Rails.logger.info("[MAIL_DEBUG] #{ActionMailer::Base.smtp_settings.inspect}")

    mail = ActionMailer::Base.mail(
      from: ENV.fetch("MAIL_FROM", "noreply@dokodate.jp"),
      to:   "あなたのメールアドレス",
      subject: "Mailtrapテスト",
      body: "Hello from dokodate!"
    )
    mail.deliver_now
    render plain: "OK"
  rescue => e
    render plain: "NG: #{e.class} #{e.message}", status: 500
  end
end
