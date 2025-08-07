class ShopsController < ApplicationController
  before_action :authenticate_user!

  def index
    @shops = Shop.all
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = Shop.new(shop_params)
    if @shop.save
      redirect_to shops_path, notice: "お店を登録しました"
    else
      render :new
    end
  end

  private
  def shop_params
    params.require(:shop).permit(:title, :address, :latitude, :longitude )
  end
end