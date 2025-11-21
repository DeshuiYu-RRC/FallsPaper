class CreateLoginHistories < ActiveRecord::Migration[7.1]
  def change
    create_table :login_histories do |t|
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.string :ip_address, limit: 45
      t.datetime :login_time

      t.timestamps
    end

    add_index :login_histories, :login_time
  end
end
