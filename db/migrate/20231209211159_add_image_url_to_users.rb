class AddImageUrlToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :image_url, :string, default: ''
  end
end
