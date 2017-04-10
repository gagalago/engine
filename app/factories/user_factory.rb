class UserFactory
  def self.build_from_server(platform, params)
    user                              = platform.users.build
    id                                = params.dig(:data, :id)
    user.public_id                    = id.blank? ? SecureRandom.uuid : id
    attributes                        = params.dig(:data, :attributes) || {}
    user.alive_at                     = attributes[:alive_at]          unless attributes[:alive_at].blank?
    user.status                       = attributes[:status]            unless attributes[:status].blank?
    user.created_at                   = attributes[:created_at]        unless attributes[:created_at].blank?
    user.updated_at                   = attributes[:updated_at]        unless attributes[:updated_at].blank?
    user
  end

  def self.update_from_server(user, params)
    id             = params.dig(:data, :id)
    user.public_id = id unless id.blank?
    user
  end
end
