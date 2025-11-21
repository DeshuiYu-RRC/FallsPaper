class CreateOrderStatuses < ActiveRecord::Migration[7.1]
  def change
    create_table :order_statuses do |t|
      t.string :status_name, null: false, limit: 50
      t.text :status_description
      t.integer :status_order, default: 0

      t.timestamps
    end

    add_index :order_statuses, :status_name, unique: true
  end
end
