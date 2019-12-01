# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatsController, type: :controller do
  render_views

  before { @chat_app = create(:chat_app) }

  let(:valid_attributes) do
    { chat: attributes_for(:chat, chat_app_id: @chat_app.id) }
  end

  let(:invalid_attributes) do
    { chat: { name: nil, number: nil, chat_app_id: 404 } }
  end

  describe 'GET #index' do
    before do
      @chats = create_list(:chat, 3, chat_app: @chat_app).sort_by(&:name)
      create_list(:chat, 2)
      get :index, params: { chat_app_token: @chat_app.token }, format: :json
    end

    it 'returns a success response' do
      expect(response.status).to eq 200
    end

    it 'returns list of chats for the chat app' do
      expect(JSON.parse(response.body).count).to eq 3
      @chats.each { |chat| expect(response.body).to include chat.name }
    end
  end

  describe 'GET #show' do
    before { @chat = create(:chat, chat_app: @chat_app) }

    it 'returns a success response' do
      get :show, params: { chat_app_token: @chat.chat_app.token, number: @chat.number }, format: :json
      expect(response).to be_successful
      expect(response.body).to include @chat.name
    end
  end

  describe 'POST #create' do
  end
end
