class AddRatingToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :rating, :decimal
  end
end
