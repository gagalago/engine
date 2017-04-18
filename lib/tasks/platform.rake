namespace :platforms do
  task list: :environment do
    ap "Available platforms:"
    ap Platform.all
  end

  task create: :environment do
    platform = PlatformFactory.build(data: { attributes: { name: ENV.fetch("name") } })
    platform.save!
    ap "Platform created!"
    ap platform
  end

  task generate_api_token: :environment do
    platform = Platform.find_by!(name: ENV.fetch("name"))
    ap "Your Token is: '#{platform.generate_jwt_token}'"
  end

  task set_messages_webhook: :environment do
    platform = Platform.find_by!(name: ENV.fetch("name"))
    platform.offline_user_message_hook_url = ENV.fetch("url")
    platform.save!
    ap "Your message digest webhook has been set to: '#{platform.offline_user_message_hook_url}'"
  end
end
