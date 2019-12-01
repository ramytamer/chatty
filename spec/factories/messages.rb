# frozen_string_literal: true

FactoryBot.define do
  factory :message do
    body { Faker::TvShows::RickAndMorty.quote }
    number { Faker::Number.unique.between(from: 1, to: 5000) }
    chat
  end
end
