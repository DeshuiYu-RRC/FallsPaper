class CreateProductsCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :products_categories do |t|
      t.string :category_name, null: false, limit: 50
      t.text :category_description

      t.timestamps
    end

    add_index :products_categories, :category_name, unique: true
  end
end
