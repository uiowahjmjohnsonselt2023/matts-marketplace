class AddPriceToItems < ActiveRecord::Migration[7.1]
  def change
    add_column :items, :price, :decimal, precision: 10, scale: 2
  end
end
