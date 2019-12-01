# frozen_string_literal: true

require 'rails_helper'
require 'sidekiq/testing'

RSpec.describe MessagesController, type: :controller do
  render_views

  before { @chat = create(:chat) }

  let(:base_params) do
    { chat_app_token: @chat.chat_app.token, chat_number: @chat.number }
  end

  let(:valid_attributes) do
    {
      message: { body: Faker::TvShows::RickAndMorty.quote }
    }.merge(base_params)
  end

  let(:invalid_attributes) do
    { message: { body: nil } }.merge(base_params)
  end

  describe 'GET #index' do
    it 'returns a success response' do
      messages = create_list(:message, 3, chat: @chat)
      get :index, params: base_params, format: :json
      expect(response.status).to eq 200
      messages.each { |message| expect(response.body).to include message.body }
    end
  end

  describe 'GET #show' do
    before { @message = create(:message, chat: @chat) }

    it 'returns a success response' do
      get :show, params: { number: @message.number }.merge(base_params), format: :json
      expect(response.status).to eq 200
      expect(response.body).to include @message.body
    end
  end

  describe 'POST #create' do
    before do
      @key = "chat_apps.#{@chat.chat_app.token}.chats.#{@chat.number}.messages.number"
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
          expect(JSON.parse(response.body)['message_number']).to eq @last_number + 1
        end
      end
    end

    context 'validates message body before creating the job' do
      before { post :create, params: invalid_attributes, format: :json }

      it 'returns 422' do
        expect(response.status).to eq 422
      end

      it 'returns errors json' do
        expect(response.body).to include "Body can't be blank"
      end

      it 'does not increment redis number' do
        expect(Redix.connection.get(@key).to_i).to eq @last_number
      end
    end
  end
end
