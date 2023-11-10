class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :city
      t.string :country
      t.string :username
      t.string :email, null: false, default: ""

      t.timestamps
    end
  end
end
