# frozen_string_literal: true

class Chat < ApplicationRecord
  include Paginated

  validates :name, :number, :chat_app, presence: true
  validates :number, uniqueness: { scope: :chat_app }

  belongs_to :chat_app
  has_many :messages

  scope :for_chat_app, ->(chat_app_id) { where(chat_app_id: chat_app_id) }
  scope :by_chat_app_token, lambda { |chat_app_token|
    joins(:chat_app).where('chat_apps.token = ?', chat_app_token)
  }
  scope :by_number, ->(chat_number) { where('chats.number = ?', chat_number) }
end
