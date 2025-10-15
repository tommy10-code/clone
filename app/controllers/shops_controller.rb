class ShopsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ]

  def index
    @q = Shop.ransack(params[:q])
    scope = @q.result.includes(:category, :scenes).order(created_at: :desc)

    # #ログイン中のユーザーがお気に入り登録したShopだけ取得
    if params[:favorited].present? && current_user
      scope = scope.favorited_by(current_user.id)
    end

    @shops = scope

    respond_to do |format|
    format.html
    format.json { render json: @shops.to_json(
      only: [ :id, :title, :address, :latitude, :longitude ],
      methods: [ :category_name, :scenes_name ]
      )
    }
    end
  end

  def autocomplete
    q = params[:q].to_s
    @shops = Shop.where("title ILIKE :q OR address ILIKE :q", q: "#{q}%").limit(5)
    render partial: "shops/autocomplete"
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
    @shop = current_user.shops.find(params[:id])
  end

  def update
    @shop = current_user.shops.find(params[:id])

    if @shop.update(shop_params)
      redirect_to shop_path(@shop), notice: "お店を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

 def destroy
    @shop = current_user.shops.find(params[:id])
    @shop.destroy
      redirect_to shops_path, status: :see_other, notice: "お店を削除しました"
  end

  private
  def shop_params
    params.require(:shop).permit(:title, :address, :latitude, :longitude, :category_id, :page, images: [], scene_ids: [])
  end
end
