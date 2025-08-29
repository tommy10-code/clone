FactoryBot.define do
  factory :shop do
    title { Faker::Book.title }
    address { Faker::Address.full_address }
    category_id { 10 }
    association :user
  end
end
