class RemoveApiKeyAndSecretFromPlatform < ActiveRecord::Migration
  def change
    remove_column :platforms, :api_key
    remove_column :platforms, :api_secret
  end
end
