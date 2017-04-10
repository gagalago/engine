class RenameIsAliveAtToAliveAt < ActiveRecord::Migration
  def change
    rename_column :users, :is_alive_at, :alive_at
  end
end
