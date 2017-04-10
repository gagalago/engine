class AddOfflineUserMessageHookUrlOnPlatforms < ActiveRecord::Migration
  def change
    add_column :platforms, :offline_user_message_hook_url, :string
  end
end
