class CreatePurchases < ActiveRecord::Migration[7.1]
  def change
    create_table :purchases do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :subtotal, null: false
      t.integer :shipping_fee, null: false
      t.integer :delivery_fee, null: false
      t.integer :tax, null: false
      t.integer :total_price, null: false
      t.date :delivery_date
      t.string :delivery_time, null: false

      t.timestamps
    end
  end
end
