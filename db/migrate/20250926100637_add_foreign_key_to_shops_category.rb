class AddForeignKeyToShopsCategory < ActiveRecord::Migration[7.2]
  def change
    add_index :shops, :category_id unless index_exists?(:shops, :category_id)
    add_foreign_key :shops, :categories, column: :category_id
  end
end
