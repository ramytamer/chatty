# frozen_string_literal: true

FactoryBot.define do
  factory :chat_app do
    name { Faker::TvShows::SiliconValley.app }
    token { SecureRandom.uuid }
  end
end
