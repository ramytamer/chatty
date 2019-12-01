# frozen_string_literal: true

class ChatApp < ApplicationRecord
  include Paginated

  validates :name, presence: true
  validates :token, presence: true, if: :persisted?
  validates :token, uniqueness: true

  before_create :set_token

  has_many :chats

  def set_token
    self.token = SecureRandom.uuid if token.blank?
  end
end
