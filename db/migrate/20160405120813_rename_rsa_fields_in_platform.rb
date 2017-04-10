class RenameRsaFieldsInPlatform < ActiveRecord::Migration
  def change
    rename_column :platforms, :rsa_public, :user_rsa_public
    rename_column :platforms, :rsa_private, :user_rsa_private
    change_column :platforms, :user_rsa_public, :text, null: false
    change_column :platforms, :user_rsa_private, :text, null: false
  end
end
