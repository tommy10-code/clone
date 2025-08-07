class AddCategoryIdToShops < ActiveRecord::Migration[7.2]
  def change
    add_column :shops, :category_id, :integer
  end
end
