require 'rails_helper'

RSpec.describe "Root", type: :request do
  describe "GET /" do
    it "200 OK を返す" do
      get root_path   # トップページにアクセス
      expect(response).to have_http_status(:ok)  # レスポンスコードが200
    end
  end
end