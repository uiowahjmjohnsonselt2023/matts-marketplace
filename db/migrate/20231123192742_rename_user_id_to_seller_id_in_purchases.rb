class RenameUserIdToSellerIdInPurchases < ActiveRecord::Migration[7.1]
  def change
    rename_column :purchases, :user_id, :seller_id
  end
end
