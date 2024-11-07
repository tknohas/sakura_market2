class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false
      t.integer :price, null: false
      t.text :description, null: false
      t.boolean :private, null: false, default: false
      t.integer :position, index: { unique: true }

      t.timestamps
    end
  end
end
