# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ChatCreationWorker, type: :worker do
  before { @chat_app = create(:chat_app) }

  after { Sidekiq::Worker.clear_all }

  context 'chat creation' do
    it 'creates a new chat with the provided name, number and chat app' do
      Sidekiq::Testing.inline! do
        expect(Chat.for_chat_app(@chat_app.id).count).to eq 0
        ChatCreationWorker.perform_async('new chat', 10, @chat_app.token)
        expect(Chat.for_chat_app(@chat_app.id).count).to eq 1
        expect(Chat.find_by(number: 10, chat_app_id: @chat_app.id).name).to eq 'new chat'
      end
    end
  end
end
