class MailTestController < ApplicationController
  def send_mail
    user = User.new(name: "テスト", email: ENV["GMAIL_ADDRESS"])
    UserMailer.welcome_email(user).deliver_now
    render plain: "OK: sent"
  rescue => e
    render plain: "NG: #{e.class} #{e.message}"
  end
end
