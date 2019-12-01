# frozen_string_literal: true

class ChatCreationWorker
  include Sidekiq::Worker

  def perform(name, number, chat_app_token)
    # I am using find_by! and create! as it should make noise so we can look into the issues and fix it instead of
    # failing silently
    # we can also add error check but I am keeping it simple for the sake of the task.
    chat_app = ChatApp.find_by!(token: chat_app_token)

    Chat.create!(name: name, number: number, chat_app_id: chat_app.id)
  end
end
