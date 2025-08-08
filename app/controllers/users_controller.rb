class UsersController < ApplicationController
  before_action :authenticate_user!

  def favorites
    @q = current_user.favorite_shops.ransack(params[:q])
    @favorite_shops = @q.result
  end
end
