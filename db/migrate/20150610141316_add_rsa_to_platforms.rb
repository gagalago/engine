class AddRsaToPlatforms < ActiveRecord::Migration
  def change
    add_column :platforms, :rsa_public, :text
    add_column :platforms, :rsa_private, :text

    Platform.all.each do |platform|
      rsa_private           = OpenSSL::PKey::RSA.generate(2048)
      platform.rsa_private  = rsa_private
      platform.rsa_public   = rsa_private.public_key
      platform.save!
    end
  end
end
