class FavoritesController < ApplicationController
  before_action :set_shop

  def favorites
    @favorite_shops = current_user.favorite_shops
  end

  def create
    current_user.bookmark(@shop)
  end

  def destroy
    current_user.unbookmark(@shop)
  end

  private

  def set_shop
    @shop = Shop.find(params[:shop_id])
  end
end
