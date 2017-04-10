class RemoveMessagesDigestHookUrlFromPlatform < ActiveRecord::Migration[5.0]
  def change
    remove_column :platforms, :messages_digest_hook_url
  end
end
