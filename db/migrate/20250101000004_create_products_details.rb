class CreateProductsDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :products_details do |t|
      t.references :product, null: false, foreign_key: true, index: { unique: true }
      t.text :explanation
      t.json :description
      t.json :specification

      t.timestamps
    end
  end
end
