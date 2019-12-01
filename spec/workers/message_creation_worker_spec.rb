# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe MessageCreationWorker, type: :worker do
  before { @chat = create(:chat) }

  after { Sidekiq::Worker.clear_all }

  context 'message creation' do
    it 'creates a new message with the provided body, number and chat number and chat app token' do
      Sidekiq::Testing.inline! do
        expect(Message.for_chat(@chat.chat_app.token, @chat.number).count).to eq 0
        MessageCreationWorker.perform_async('hello there', 10, @chat.number, @chat.chat_app.token)
        expect(Message.for_chat(@chat.chat_app.token, @chat.number).count).to eq 1
        expect(Message.for_chat(@chat.chat_app.token, @chat.number).first.body).to include 'hello there'
      end
    end
  end
end
