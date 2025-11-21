class CreateRoles < ActiveRecord::Migration[7.1]
  def change
    create_table :roles do |t|
      t.string :role_name, null: false, limit: 50
      t.text :role_description

      t.timestamps
    end

    add_index :roles, :role_name, unique: true
  end
end
