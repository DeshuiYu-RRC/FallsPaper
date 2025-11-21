class DeviseCreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      # Basic info
      t.string :username, null: false, limit: 50

      # Devise fields
      t.string :email, null: false, default: ""
      t.string :encrypted_password, null: false, default: ""
      t.string :reset_password_token
      t.datetime :reset_password_sent_at
      t.datetime :remember_created_at

      # Custom fields
      t.boolean :is_verified, default: true
      t.references :role, foreign_key: true

      # Address fields
      t.string :address
      t.string :city
      t.string :postal_code, limit: 10
      t.references :province, foreign_key: true
      t.string :phone, limit: 20

      t.timestamps null: false
    end

    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :is_verified
  end
end
