class CreateShops < ActiveRecord::Migration[7.2]
  def change
    create_table :shops do |t|
      t.string :title
      t.text :body
      t.string :address
      t.string :image
      t.integer :user_id
      t.float :latitude
      t.float :longitude
      t.timestamps
    end
  end
end
