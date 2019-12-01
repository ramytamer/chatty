# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe ChatsController, type: :controller do
  render_views

  before { @chat_app = create(:chat_app) }

  let(:valid_attributes) do
    { chat: { name: Faker::TvShows::SiliconValley.invention }, chat_app_token: @chat_app.token }
  end

  let(:invalid_attributes) do
    { chat: { name: nil }, chat_app_token: @chat_app.token }
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
    before do
      @key = "chat_apps.#{@chat_app.token}.chats.number"
      @last_number = Redix.connection.incr(@key)
    end

    after do
      Redix.connection.del(@key)
      Sidekiq::Worker.clear_all
    end

    context 'create chat job' do
      it 'increment number in redis' do
        post :create, params: valid_attributes, format: :json
        Sidekiq::Testing.inline! do
          expect(response.status).to eq 201
          expect(Redix.connection.get(@key).to_i).to eq @last_number + 1
          expect(JSON.parse(response.body)['chat_number']).to eq @last_number + 1
        end
      end
    end

    context 'validates chat name before creating the job' do
      before { post :create, params: invalid_attributes, format: :json }

      it 'returns 422' do
        expect(response.status).to eq 422
      end

      it 'returns errors json' do
        expect(response.body).to include "Name can't be blank"
      end

      it 'does not increment redis number' do
        expect(Redix.connection.get(@key).to_i).to eq @last_number
      end
    end
  end
end
