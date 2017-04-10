class AddMessageDigestUrlToPlatform < ActiveRecord::Migration
  def change
    add_column :platforms, :messages_digest_hook_url, :string
  end
end
