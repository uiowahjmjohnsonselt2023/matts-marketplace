class AddBuyerRefToPurchases < ActiveRecord::Migration[7.1]
  def change
    add_reference :purchases, :buyer, null: false, foreign_key: { to_table: :users }
  end
end
