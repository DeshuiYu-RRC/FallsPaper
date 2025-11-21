class CreateProducts < ActiveRecord::Migration[7.1]
  def change
    create_table :products do |t|
      t.string :name, null: false, limit: 255
      t.text :quantity
      t.integer :stock, null: false, default: 0
      t.text :image
      t.references :products_category, foreign_key: true
      t.decimal :current_price, precision: 10, scale: 2, null: false
      t.decimal :original_price, precision: 10, scale: 2, null: false
      t.decimal :bulk_price, precision: 10, scale: 2, null: false

      t.timestamps
    end

    add_index :products, :name, unique: true
    add_index :products, :current_price
    add_index :products, :original_price
  end
end
