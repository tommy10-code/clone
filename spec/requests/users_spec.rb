require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET /users/sign_in" do
    it "会員登録ページが表示される" do
      get new_user_registration_path	
      expect(response).to have_http_status(200)
      expect(response.body).to include("会員登録")
    end
  end
end
