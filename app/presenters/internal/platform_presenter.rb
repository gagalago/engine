class Internal::PlatformPresenter < BasePresenter
  def data
    {
      type:      "platform",
      id:        @object.id,
      attributes: {
        name:              @object.name,
        userRsaPublic:     @object.user_rsa_public,
        platformRsaPublic: @object.platform_rsa_public
      }
    }
  end
end
