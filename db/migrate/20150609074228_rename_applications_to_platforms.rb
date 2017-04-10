class RenameApplicationsToPlatforms < ActiveRecord::Migration
  def change
    rename_table :applications, :platforms
    rename_column :users, :application_id, :platform_id
  end
end
