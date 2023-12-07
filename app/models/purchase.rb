class Purchase < ApplicationRecord
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :item

  def confirm_purchase?
    buyer = self.buyer
    seller = self.seller
    item = self.item

    # Check if the buyer has enough balance and the item is for sale
    if buyer.balance >= item.price && item.for_sale
      ActiveRecord::Base.transaction do
        # Update the buyer's balance and the item's for_sale attribute
        buyer.balance -= item.price
        seller.balance += item.price
        item.for_sale = false
        item.sold = true
        if buyer.save && item.save && seller.save
          # If both save successfully, save the purchase
          if self.save
            return true
          else
            # If the purchase fails to save, raise an exception to rollback the transaction
            raise ActiveRecord::Rollback
          end
        else
          raise ActiveRecord::Rollback
        end
      end
    end
    false
  end
end
