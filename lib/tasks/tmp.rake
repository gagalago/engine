namespace :tmp do
  task :find_duplicate_messages => :environment do
    API_KEY = ENV["API_KEY"] || "BABWAAK"
    API_SECRET = ENV["API_SECRET"] || "BABWAAS"
    platform = Platform.find_by(api_secret: API_SECRET, api_key: API_KEY)
    duplicated_messages_ids = []
    platform.rooms.each do |room|
      puts "Room #{room.id} #{room.name}"
      messages = room.messages.order(created_at: :asc)
      if messages.size > 0
        puts "FIRST MESSAGES #{messages.first.id} #{messages.first.content}"
        messages.each do |message|
          if messages.first.id != message.id && message.content == messages.first.content
            puts "SAME MESSAGE #{message.id} AS FIRST #{message.content}"
            duplicated_messages_ids.push(message.id)
          end
        end
      end
    end
    puts duplicated_messages_ids.inspect
  end
end
