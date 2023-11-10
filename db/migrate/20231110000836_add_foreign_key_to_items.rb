class AddForeignKeyToItems < ActiveRecord::Migration[7.1]
  def change
    add_reference :items, :user, foreign_key: true
  end
end