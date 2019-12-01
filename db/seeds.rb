# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Chat.destroy_all
ChatApp.destroy_all
5.times do
  chat_app = ChatApp.create!(name: Faker::TvShows::SiliconValley.app, token: SecureRandom.uuid)

  3.times do |i|
    Chat.create!(chat_app_id: chat_app.id, name: Faker::TvShows::SiliconValley.invention, number: i + 1)
  end
end
