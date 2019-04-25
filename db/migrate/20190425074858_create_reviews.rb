class CreateReviews < ActiveRecord::Migration[5.2]
  def change
    create_table :reviews do |t|
      t.references :product, foreign_key: true
      t.string :description
      t.decimal :review, precision: 3, scale: 2

      t.timestamps
    end
  end
end
