FactoryBot.define do
  factory :user do
    name  { "太郎" }
    sequence(:email) { |n| "taro_#{n}@example.com" }
    password { "password" }
    password_confirmation { "password" }
  end
end
