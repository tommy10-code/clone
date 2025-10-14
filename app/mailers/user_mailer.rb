class UserMailer < ApplicationMailer
  default from: "noreply@example.com"

  def welcome_email(user)
    @user = user
    mail(to: @user.email, subject: "会員登録完了のお知らせ")
  end
end
