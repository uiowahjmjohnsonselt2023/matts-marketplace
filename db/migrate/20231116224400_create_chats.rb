class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.references :buyer, foreign_key: { to_table: :users },null: false
      t.references :seller, foreign_key: { to_table: :users },  null: false

      t.timestamps
    end
  end
end
