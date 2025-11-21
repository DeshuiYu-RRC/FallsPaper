class CreateOrders < ActiveRecord::Migration[7.1]
  def change
    create_table :orders do |t|
      t.string :order_number, null: false, limit: 50
      t.references :user, null: false, foreign_key: { on_delete: :cascade }

      # Customer info
      t.string :customer_name, null: false, limit: 100
      t.string :customer_phone, null: false, limit: 20
      t.string :customer_email, limit: 100

      # Delivery address
      t.text :delivery_address, null: false
      t.string :delivery_city, limit: 50
      t.string :delivery_postal_code, limit: 10

      # Order amounts
      t.decimal :subtotal, precision: 10, scale: 2, null: false
      t.decimal :tax_gst, precision: 10, scale: 2, default: 0
      t.decimal :tax_pst, precision: 10, scale: 2, default: 0
      t.decimal :tax_amount, precision: 10, scale: 2, default: 0
      t.decimal :delivery_fee, precision: 10, scale: 2, default: 0
      t.decimal :total_amount, precision: 10, scale: 2, null: false

      # Status and notes
      t.references :order_status, null: false, foreign_key: true
      t.text :customer_notes
      t.text :admin_notes

      # Timestamps
      t.datetime :confirmed_at
      t.datetime :shipped_at
      t.datetime :delivered_at

      t.timestamps
    end

    add_index :orders, :order_number, unique: true
    add_index :orders, :customer_phone
  end
end
