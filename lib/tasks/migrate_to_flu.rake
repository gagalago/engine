namespace :v2 do
  task fix_data: :environment do
    fix_foreign_keys
    delete_platforms
  end

  task generate_events: :environment do
    Flu.init
    Flu.start
    service = Flu::Util::ExportService.new
    service.export_existing_entities_to_events(Flu.event_publisher, Flu.event_factory)
  end

  private

  def delete_platforms
    ## dev: 0b20492f-802e-483e-be27-e176d35c7888
    commuty_platform_id = ENV["PLATFORM_TO_KEEP"] || "48ce5000-cc0b-4c80-9028-8dad4710e5da"
    ActiveRecord::Base.transaction do
      ActiveRecord::Base.connection.execute("DELETE FROM users WHERE platform_id<>'#{commuty_platform_id}'")
      ActiveRecord::Base.connection.execute("DELETE FROM rooms WHERE platform_id<>'#{commuty_platform_id}'")
      ActiveRecord::Base.connection.execute("DELETE FROM platforms WHERE id<>'#{commuty_platform_id}'")
      ActiveRecord::Base.connection.execute("
        DELETE FROM memberships m
        WHERE NOT EXISTS (SELECT 1 FROM users WHERE m.user_id=id)
        OR NOT EXISTS (SELECT 1 FROM rooms WHERE m.room_id=id)
      ")
      ActiveRecord::Base.connection.execute("
        DELETE FROM messages m
        WHERE NOT EXISTS (SELECT 1 FROM rooms WHERE m.room_id=id)
      ")
    end
  end

  def fix_foreign_keys
    ActiveRecord::Base.connection.execute("
        DELETE FROM messages m
        WHERE m.sender_id IS NOT NULL
        AND NOT EXISTS (SELECT 1 FROM users WHERE id=m.sender_id)")
    ActiveRecord::Base.connection.execute("
        DELETE FROM rooms r
        WHERE NOT EXISTS (SELECT 1 FROM users WHERE id=r.initiator_id)
      ")
  end
end
