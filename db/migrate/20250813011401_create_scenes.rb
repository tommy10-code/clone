class CreateScenes < ActiveRecord::Migration[7.2]
  def change
    create_table :scenes do |t|
      t.string :name
      t.string :slug

      t.timestamps
    end
    add_index :scenes, :name, unique: true
    add_index :scenes, :slug
  end
end
