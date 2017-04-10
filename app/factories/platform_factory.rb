class PlatformFactory
  def self.build(params)
    user_rsa_private              = OpenSSL::PKey::RSA.generate(2048)
    platform_rsa_private          = OpenSSL::PKey::RSA.generate(2048)
    platform                      = Platform.new
    platform.name                 = params.dig(:data, :attributes, :name)
    platform.user_rsa_private     = user_rsa_private
    platform.user_rsa_public      = user_rsa_private.public_key
    platform.platform_rsa_private = platform_rsa_private
    platform.platform_rsa_public  = platform_rsa_private.public_key
    platform
  end
end
