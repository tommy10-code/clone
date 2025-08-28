require 'rails_helper'

RSpec.describe Shop, type: :model do
  describe "バリデーション" do
    it "全ての情報を入力して登録ができるのか？" do
      user = create(:user)
      shop = Shop.new(title:"aaa", address:"aaa", category_id: 10, user: user)
      expect(shop).to be_valid
    end

    it "名前が必須" do
      user = create(:user)
      shop = build(:shop, title: nil)
      expect(shop).to be_invalid
      expect(shop.errors[:title]).to include("を入力してください")
    end

  end
end