namespace :platform do
  task create: :environment do
    rsa_private = OpenSSL::PKey::RSA.generate(2048)
    Platform.create(
      name:         ENV["name"],
      api_key:      ENV["api_key"],
      api_secret:   ENV["api_secret"],
      rsa_private:  rsa_private,
      rsa_public:   rsa_private.public_key
    )
  end

  task reset_keys_or_create: :environment do
    platform            = Platform.find_or_initialize_by(name: ENV["name"])
    platform.api_key    = ENV["api_key"]
    platform.api_secret = ENV["api_secret"]
    platform.save!
  end
end
