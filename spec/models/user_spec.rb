# まずはmodel specを10個 userとshop5個ずつ

require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "全ての情報があって登録ができるか" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "名前がないと登録できない" do
      user = build(:user, name: nil)
      expect(user).to be_invalid
      expect(user.errors[:name]).to include("を入力してください")
    end

    it "メールアドレス必須" do
      user = build(:user, email: nil)
      expect(user).to be_invalid
      expect(user.errors[:email]).to include("を入力してください")
    end

    it "メールアドレス登録重複禁止" do
      create(:user, email: "test@example.com")
      user = User.new(email: "test@example.com")
      expect(user).to be_invalid
      expect(user.errors[:email]).to include("を登録できませんでした。すでにご登録済みか、入力内容に誤りがあります")
    end

    it "パスワード５文字以下でエラー" do
      user = build(:user, password: "aaaaa")
      expect(user).to be_invalid
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end
  end
end
