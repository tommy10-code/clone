require 'rails_helper'

RSpec.describe User, type: :model do
  it "nameがあれば有効" do
    user = create(:user)
    expect(user).to be_valid
  end
end
