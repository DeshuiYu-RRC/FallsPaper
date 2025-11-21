class CreateProvinces < ActiveRecord::Migration[7.1]
  def change
    create_table :provinces do |t|
      t.string :code, null: false, limit: 2
      t.string :name, null: false, limit: 50
      t.decimal :gst_rate, precision: 5, scale: 4, default: 0.0
      t.decimal :pst_rate, precision: 5, scale: 4, default: 0.0
      t.decimal :hst_rate, precision: 5, scale: 4, default: 0.0

      t.timestamps
    end

    add_index :provinces, :code, unique: true
    add_index :provinces, :name, unique: true
  end
end
