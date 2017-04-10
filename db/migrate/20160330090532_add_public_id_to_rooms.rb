class AddPublicIdToRooms < ActiveRecord::Migration
  def change
    add_column :rooms, :public_id, :string
    ActiveRecord::Base.connection.execute("UPDATE rooms SET public_id=id;")
    add_index :rooms, [:platform_id, :public_id], unique: true
    change_column :rooms, :public_id, :string, null: false
  end
end
