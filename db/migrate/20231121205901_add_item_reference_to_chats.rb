class AddItemReferenceToChats < ActiveRecord::Migration[7.1]
  def change
    add_reference :chats, :item, null: false, foreign_key: true
  end
end
