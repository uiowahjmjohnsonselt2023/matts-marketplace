class AddBannedToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :banned, :boolean, default: false
  end
end
