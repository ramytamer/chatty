# frozen_string_literal: true

# For docker purposes: https://github.com/mperham/sidekiq/wiki/Using-Redis#using-an-initializer

Sidekiq.configure_server do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
end
