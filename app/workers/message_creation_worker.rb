# frozen_string_literal: true

class MessageCreationWorker
  include Sidekiq::Worker

  def perform(body, number, chat_number, chat_app_token)
    chat = Chat.by_chat_app_token(chat_app_token).by_number(chat_number).first

    Message.create!(body: body, number: number, chat_id: chat.id)
  end
end
