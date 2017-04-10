class AddDeviceSessionIdToMessages < ActiveRecord::Migration
  def change
    add_column :messages, :device_session_id, :string
  end
end
