# frozen_string_literal: true

require 'redis'

module Redix
  def connection
    @connection ||= new_connection
  end

  def new_connection
    Redis.new(url: Rails.configuration.redis_url)
  rescue e
    puts e.inspect
  end

  module_function :connection, :new_connection
end
