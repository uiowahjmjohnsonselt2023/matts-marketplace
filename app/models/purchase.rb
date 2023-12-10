class Purchase < ApplicationRecord
  belongs_to :seller, class_name: 'User', foreign_key: 'seller_id'
  belongs_to :buyer, class_name: 'User', foreign_key: 'buyer_id'
  belongs_to :item

  def confirm_purchase?
    buyer = self.buyer
    seller = self.seller
    item = self.item
    root_admin = User.find_by(root_admin: true)
    order_total = item.price * 1.02

    # Check if the buyer has enough balance and the item is for sale
    if buyer.balance >= order_total && item.for_sale
      ActiveRecord::Base.transaction do
        # Update the buyer's balance and the item's for_sale attribute
        buyer.balance -= order_total
        seller.balance += item.price

        # add the 2 percent from the order_total to the root admin's balance
        root_admin.balance += item.price * 0.02

        item.for_sale = false
        item.sold = true
        if buyer.save && item.save && seller.save && root_admin.save
          # If both save successfully, save the purchase
          if self.save
            return true
          else
            # If the purchase fails to save, raise an exception to rollback the transaction
            errors.add(:base, "Something went wrong saving the purchase. Please try again later.")
            raise ActiveRecord::Rollback
          end
        else
          errors.add(:base, "Something went wrong saving the purchase. Please try again later.")
          raise ActiveRecord::Rollback
        end
      end
    end
    if buyer.balance < item.price
      errors.add(:base, "You do not have enough balance to purchase this item.")
    elsif !item.for_sale
      errors.add(:base, "This item is no longer for sale.")
    end
    false
  end
end
