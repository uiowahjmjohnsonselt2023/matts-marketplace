class AddRootAdminToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :root_admin, :boolean, default: false
  end
end
