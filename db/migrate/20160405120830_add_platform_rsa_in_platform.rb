class AddPlatformRsaInPlatform < ActiveRecord::Migration
  def change
    add_column :platforms, :platform_rsa_public, :text
    add_column :platforms, :platform_rsa_private, :text
    Platform.all.each do |platform|
      rsa_private                    = OpenSSL::PKey::RSA.generate(2048)
      platform.platform_rsa_private  = rsa_private
      platform.platform_rsa_public   = rsa_private.public_key
      platform.save!
    end
    change_column :platforms, :platform_rsa_public, :text, null: false
    change_column :platforms, :platform_rsa_private, :text, null: false
  end
end
