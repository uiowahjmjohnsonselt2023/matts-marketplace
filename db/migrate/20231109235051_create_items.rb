class CreateItems < ActiveRecord::Migration[7.1]
  def change
    create_table :items do |t|
      t.float :price
      t.string :description
      t.string :image_url
      t.string :category
      t.boolean :for_sale

      t.timestamps
    end
  end
end
