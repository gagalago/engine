class RoomFactory
  def self.build_from_client(platform, initiator, params)
    room                  = platform.rooms.build
    room.initiator        = initiator
    room.last_activity_at = Time.zone.now

    id                    = params.dig(:data, :id)
    room.public_id        = id.blank? ? SecureRandom.uuid : id

    attributes            = params.dig(:data, :attributes) || {}
    room.name             = attributes[:name] unless attributes[:name].blank?

    relationships         = params.dig(:data, :relationships) || {}
    users                 = relationships.dig(:users, :data) || []
    users.push(id: initiator.public_id)

    users                 = platform.users.where(public_id: users.map { |u| u[:id] })
    users.each do |user|
      room.memberships.build(user: user)
    end
    room
  end

  def self.update_from_client(room, params)
    room.name = params.dig(:data, :attributes, :name)
    room
  end

  def self.update_from_server(room, params)
    attributes     = params.dig(:data, :attributes) || {}
    room.name      = attributes[:name] unless attributes[:name].blank?
    id             = params.dig(:data, :id)
    room.public_id = id unless id.blank?
    room
  end

  def self.build_from_server(platform, params)
    room                  = platform.rooms.build
    id                    = params.dig(:data, :id)
    room.public_id        = id.blank? ? SecureRandom.uuid : id
    room.last_activity_at = Time.zone.now

    attributes            = params.dig(:data, :attributes) || {}
    room.name             = attributes[:name]       unless attributes[:name].blank?
    room.created_at       = attributes[:created_at] unless attributes[:created_at].blank?
    room.updated_at       = attributes[:updated_at] unless attributes[:updated_at].blank?

    relationships = params.dig(:data, :relationships) || {}
    users         = relationships.dig(:users, :data) || []
    initiator_id  = relationships.dig(:initiator, :data, :id)

    if initiator_id
      room.initiator = platform.users.find(initiator_id)
      users.push(id: initiator.public_id)
    end

    users                 = platform.users.where(public_id: users.map { |u| u[:id] })
    users.each do |user|
      room.memberships.build(user: user)
    end

    room
  end
end
