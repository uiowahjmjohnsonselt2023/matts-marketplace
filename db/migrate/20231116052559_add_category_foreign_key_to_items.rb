class AddCategoryForeignKeyToItems < ActiveRecord::Migration[7.1]
  def change
    remove_column :items, :category    # Remove the existing column
    add_reference :items, :category, foreign_key: true
  end
end
