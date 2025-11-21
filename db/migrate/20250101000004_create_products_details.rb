class CreateProductsDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :products_details do |t|
      t.references :product, null: false, foreign_key: true
      t.text :explanation
      t.json :description
      t.json :specification

      t.timestamps
    end

    add_index :products_details, :product_id, unique: true
  end
end
