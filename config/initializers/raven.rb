if !Rails.env.development? && !Rails.env.test?
  require "raven"
  Raven.configure do |config|
    config.dsn          = ENV["SENTRY_DSN"]
    config.environments = %w[ staging production ]
  end
end
