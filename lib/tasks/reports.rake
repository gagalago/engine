namespace :reports do
  task compute: :environment do
    MessageDailyMetricsReport.destroy_all
    UserDailyMetricsReport.destroy_all
    RoomDailyMetricsReport.destroy_all

    Message.all.each do |message|
      MessageDailyMetricsReport.update_with_message!(message)
    end

    User.all.each do |user|
      UserDailyMetricsReport.update_with_user!(user)
    end

    Room.all.each do |room|
      RoomDailyMetricsReport.update_with_room!(room)
    end
  end
end
