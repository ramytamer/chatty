# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Message.destroy_all
Chat.destroy_all
ChatApp.destroy_all
5.times do
  chat_app = ChatApp.create!(name: Faker::TvShows::SiliconValley.app, token: SecureRandom.uuid)

  3.times do |i|
    chat = Chat.create!(chat_app_id: chat_app.id, name: Faker::TvShows::SiliconValley.invention, number: i + 1)

    4.times do |j|
      Message.create!(chat_id: chat.id, body: Faker::TvShows::RickAndMorty.quote, number: j + 1)
    end
  end
end

Message.__elasticsearch__.create_index!
Message.import
