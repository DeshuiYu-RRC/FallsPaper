class AddStripeFieldsToOrders < ActiveRecord::Migration[7.1]
  def change
    add_column :orders, :stripe_payment_intent_id, :string
    add_column :orders, :stripe_payment_status, :string
  end
end
