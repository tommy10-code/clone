class OnboardingsController < ApplicationController
  before_action :authenticate_user!

  def update
    if params[:hide_onboarding_banner] == true || params[:hide_onboarding_banner] == "true"
      current_user.update(hide_onboarding_banner: true)
    end
    head :no_content
  end
end
