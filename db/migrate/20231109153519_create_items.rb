class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.float :price
      t.text :description
      t.string :image_url
      t.string :catagory
      t.boolean :for_sale

      t.timestamps
    end
  end
end
