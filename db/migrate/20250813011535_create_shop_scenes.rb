class CreateShopScenes < ActiveRecord::Migration[7.2]
  def change
    create_table :shop_scenes do |t|
      t.references :shop, null: false, foreign_key: true
      t.references :scene, null: false, foreign_key: true
      t.integer :votes_count
      t.timestamps
    end
  end
end
