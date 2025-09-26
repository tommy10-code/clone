# 名前を変更したい時
# cat = Category.find_by(name: "イタリアン")
# if cat
#   cat.update!(name: "イタリアン料理")
# else
#   Category.find_or_create_by!(name: "イタリアン料理")
# end
# bin/rails db:seed 実行したらこのif文は削除

categories = %w[  イタリアン フレンチ 和食・割烹 韓国料理 中華・四川 カフェ・喫茶店 バー・ダイニングバー ビストロ パンケーキ・スイーツ系 居酒屋・創作料理]
categories.each do |n|
  Category.find_or_create_by!(name: n)
end


scenes = %w[初デート 個室有 隠れ家 照明やや暗め ]
scenes.each do |n|
  Scene.find_or_create_by!(name: n) do |s|
    s.slug = n.parameterize # slug使うなら
  end
end
