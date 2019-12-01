# frozen_string_literal: true

class Chat < ApplicationRecord
  include Paginated

  validates :name, :number, :chat_app, presence: true
  validates :number, uniqueness: { scope: :chat_app }

  belongs_to :chat_app

  scope :for_chat_app, ->(chat_app_id) { where(chat_app_id: chat_app_id) }
end
