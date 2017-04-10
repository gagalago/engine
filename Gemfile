source "http://rubygems.org"

gem "pg",                  "0.19.0"
gem "jwt",                 "1.5.6"
gem "rails",               "5.0.1"
gem "sentry-raven",        "2.3.0", require: false
gem "sidekiq",             "4.2.9"
gem "awesome_print",       "1.7.0"
gem "rest-client",         "2.0.0"
gem "unicorn",             "5.2.0"
gem "flu-rails",           git: "https://github.com/crepesourcing/flu-rails.git"
gem "sidekiq-unique-jobs", "4.0.18"
gem "rack-cors",           "0.4.0", require: "rack/cors"

group :development do
  gem "annotate", git: "https://github.com/ctran/annotate_models.git", branch: "develop"
end

group :development, :test do
  gem "rspec-rails",      "3.5.2"
  gem "database_cleaner", "1.5.1"
end
