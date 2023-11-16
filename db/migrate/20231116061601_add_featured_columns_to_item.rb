class AddFeaturedColumnsToItem < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :featured, :boolean
    add_column :items, :featured_amount_paid, :decimal
  end
end
