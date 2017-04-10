class AddPublicIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :public_id, :string
    ActiveRecord::Base.connection.execute("UPDATE users SET public_id=id;")
    add_index :users, [:platform_id, :public_id], unique: true
    change_column :users, :public_id, :string, null: false
  end
end
