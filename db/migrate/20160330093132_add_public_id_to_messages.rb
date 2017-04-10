class AddPublicIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :public_id, :string
    ActiveRecord::Base.connection.execute("UPDATE messages SET public_id=id;")
    add_index :messages, [:room_id, :public_id], unique: true
    change_column :messages, :public_id, :string, null: false
  end
end
