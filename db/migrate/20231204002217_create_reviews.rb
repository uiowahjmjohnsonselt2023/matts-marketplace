class CreateReviews < ActiveRecord::Migration[7.1]
  def change
    create_table :reviews do |t|
      t.string :content
      t.integer :rating
      t.string :title
      t.references :reviewer, foreign_key: { to_table: :users },null: false
      t.references :reviewee, foreign_key: { to_table: :users },null: false

      t.timestamps
    end
  end
end
