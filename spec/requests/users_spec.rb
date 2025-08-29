require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:name) { "太郎" }
  let(:password) { "password123!" }
  let(:email) { "tester@example.com" }
  describe "トップページ各ページが表示できるか" do
    # 失敗系サインアップの共通処理
    def user_request_spec(overrides = {})
      base = {
        name: name,
        email: email,
        password: password,
        password_confirmation: password
      }

      expect { post user_registration_path, params: { user: base.merge(overrides) } }.not_to change(User, :count)
      expect([ 200, 422 ]).to include(response.status)
    end

      it "会員登録ページが表示される" do
        get new_user_registration_path
        expect(response).to have_http_status(200)
        expect(response.body).to include("会員登録")
      end

      it "ログインページが表示される" do
        get new_user_session_path
        expect(response).to have_http_status(200)
        expect(response.body).to include("ログイン")
      end

    context "有効なパラメータの時" do
      it "会員登録ができるか" do
        expect {
          post user_registration_path, params: {
            user: {
              name: "テスト",
              email: "tester@example.com",
              password: "password",
              password_confirmation: "password"
            }
          }
        }.to change(User, :count).by(1)
      end
    end

    context "無効なパラメータとの時" do
      it "メールアドレスが不正形式だと作成されない" do
        user_request_spec(
          { email: "invalid_email" })
      end

      it "パスワードが一致しないと作成されない" do
        user_request_spec(
          { password: "passwords", password_confirmation: "password" })
      end
    end
  end
end
