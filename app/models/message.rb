# frozen_string_literal: true

class Message < ApplicationRecord
  include Paginated

  validates :body, :number, :chat, presence: true
  validates :number, uniqueness: { scope: :chat }

  belongs_to :chat
  has_one :chat_app, through: :chat

  scope :for_chat, lambda { |chat_app_token, chat_number|
    joins(chat: :chat_app).where('chat_apps.token = ? and chats.number = ?', chat_app_token, chat_number)
  }
  scope :by_number, ->(message_number) { where('messages.number = ?', message_number) }
end
