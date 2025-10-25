class OnboardingsController < ApplicationController
  before_action :authenticate_user!

  def update
    #受け取ったパラメータがtrueならっていう処理 trueに変更、違うなら何もしない
    if params[:hide_onboarding_banner] == true || params[:hide_onboarding_banner] == "true"
      current_user.update(hide_onboarding_banner: true)
    end
    head :no_content
  end
end
