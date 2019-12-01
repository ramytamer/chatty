# frozen_string_literal: true

FactoryBot.define do
  factory :chat do
    name { Faker::TvShows::SiliconValley.invention }
    number { Faker::Number.unique.between(from: 1, to: 5000) }
    chat_app
  end
end
