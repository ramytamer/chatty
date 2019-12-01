# frozen_string_literal: true

class Chat < ApplicationRecord
  include Paginated

  validates :name, :number, :chat_app, presence: true
  validates :number, uniqueness: { scope: :chat_app }

  belongs_to :chat_app
end
