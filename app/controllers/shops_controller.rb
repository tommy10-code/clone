class ShopsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]

  def index
    @q = Shop.ransack(params[:q])
    @shops = @q.result.includes(:category, :scenes).order(created_at: :desc)
  end

  def autocomplete
    q = params[:q].to_s
    @shops = Shop.where("title ILIKE :q OR address ILIKE :q", q: "#{q}%").limit(5)
    render partial: "shops/autocomplete"  # ← HTML fragment を返す！
  end

  def show
    @shop = Shop.find(params[:id])
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = current_user.shops.new(shop_params)
    if @shop.save
      redirect_to shops_path, notice: "お店を登録しました", status: :see_other
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @shop = current_user.shops.find(params[:id])     # ← 自分の投稿だけ拾う
  end

  def update
    @shop = current_user.shops.find(params[:id])     # ← 自分の投稿だけ拾う

    if @shop.update(shop_params)
      redirect_to shop_path(@shop), notice: "お店を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

 def destroy
    @shop = current_user.shops.find(params[:id])     # ← 自分の投稿だけ拾う
    @shop.destroy
      redirect_to shops_path, status: :see_other, notice: "お店を削除しました"
  end

  private
  def shop_params
    params.require(:shop).permit(:title, :address, :latitude, :longitude, :category_id, :page, images: [], scene_ids: [])
  end
end
