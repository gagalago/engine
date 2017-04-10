# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

if Rails.env.development?
  rsa_private = OpenSSL::PKey::RSA.generate(2048)
  platform    = Platform.create(
    name: "Babili Web",
    api_key:      "BABILIAPIKEYBW",
    api_secret:   "BABILIAPISECRETBW",
    rsa_private:  rsa_private,
    rsa_public:   rsa_private.public_key
  )
end
