# frozen_string_literal: true

require 'elasticsearch/model'

class Message < ApplicationRecord
  include Paginated
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks # auto-index

  settings index: { number_of_shards: 1 } do
    mappings dynamic: 'false' do
      indexes :body, type: :text
      indexes :chat_id, type: :integer
    end
  end

  validates :body, :number, :chat, presence: true
  validates :number, uniqueness: { scope: :chat }

  belongs_to :chat
  has_one :chat_app, through: :chat

  scope :for_chat, lambda { |chat_app_token, chat_number|
    joins(chat: :chat_app).where('chat_apps.token = ? and chats.number = ?', chat_app_token, chat_number)
  }
  scope :by_number, ->(message_number) { where('messages.number = ?', message_number) }
  scope :newst_first, -> { order(id: :desc) }

  def self.es_search(query, chat_id)
    search(query: { bool: { must: [{ match: { body: query } }, { match: { chat_id: chat_id } }] } })
  end
end
