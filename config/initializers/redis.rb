# frozen_string_literal: true

require 'redis'

begin
  $redis = Redis.new(url: Rails.configuration.redis_url)
rescue e
  puts e.inspect
end
