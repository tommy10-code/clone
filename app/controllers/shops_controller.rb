class ShopsController < ApplicationController
  before_action :authenticate_user!

  def index
    @q = Shop.ransack(params[:q])
    @shops = @q.result.includes(:category, :scenes).order(created_at: :desc)
  end

  def show
    @shop = Shop.find(params[:id])
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

  def edit
	  @shop = Shop.find(params[:id])
  end

  def update
	  @shop = Shop.find(params[:id])

    if @shop.update(shop_params)
      redirect_to shop_path(@shop), notice: "User was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

 def destroy
 	  @shop = Shop.find(params[:id])
    @shop.destroy
      redirect_to shops_path, status: :see_other, notice: "User was successfully destroyed."
  end

  private
  def shop_params
    params.require(:shop).permit(:title, :address, :latitude, :longitude, :category_id, :page, images: [], scene_ids: [] )
  end
end