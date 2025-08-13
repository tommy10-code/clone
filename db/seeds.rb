# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
Category.create!(name: "イタリアン")
Category.create!(name: "フレンチ")
Category.create!(name: "和食・割烹")
Category.create!(name: "韓国料理")
Category.create!(name: "中華・四川")
Category.create!(name: "カフェ・喫茶店")
Category.create!(name: "バー・ダイニングバー")
Category.create!(name: "ビストロ")
Category.create!(name: "パンケーキ・スイーツ系")
Category.create!(name: "居酒屋・創作料理")

scenes = %w[初デート 2回目以降 記念日 サク飯 静かに話せる 大人っぽい]
scenes.each do |n|
  Scene.find_or_create_by!(name: n) do |s|
    s.slug = n.parameterize # slug使うなら
  end
end