class Users::OmniauthCallbacksController < ApplicationController
  def google_oauth2
      auth = request.env["omniauth.auth"]
      @user = Users::FindOrCreateFromOmniauth.call(auth: auth)

    if @user.persisted?
      sign_in @user, event: :authentication
      redirect_to shops_path, notice: "Googleアカウントでログインしました"
      nil
    else
      redirect_to new_user_registration_url, alert: "ログインに失敗しました"
      nil
    end
  end
end
