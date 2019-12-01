# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatAppsController, type: :controller do
  render_views

  describe '#index' do
    before { @chat_apps = create_list(:chat_app, 3).sort_by(&:name) }

    context 'it fetches all chat apps' do
      before { get :index, format: :json }

      it 'returns all chat apps' do
        expect(response.status).to eq 200
        body = JSON.parse(response.body).sort_by { |c| c['name'] }
        3.times { |i| expect(body[i]['name']).to eq @chat_apps[i].name }
      end
    end

    context 'it get chat apps paginated' do
      it 'returns only one chat app per page' do
        get :index, params: { per_page: 1, page: 1 }, format: :json
        expect(JSON.parse(response.body).length).to eq 1
        get :index, params: { per_page: 1, page: 2 }, format: :json
        expect(JSON.parse(response.body).length).to eq 1
        get :index, params: { per_page: 1, page: 3 }, format: :json
        expect(JSON.parse(response.body).length).to eq 1
        get :index, params: { per_page: 1, page: 4 }, format: :json
        expect(JSON.parse(response.body).length).to eq 0
      end
    end
  end

  describe '#show' do
    before { @chat_app = create(:chat_app) }

    context 'it fetch chat app by token' do
      before { get :show, params: { token: @chat_app.token }, format: :json }

      it 'returns the chat app' do
        expect(response.status).to eq 200
        expect(response.body).to include @chat_app.name
      end
    end

    context 'it returns not found if not token is invalid' do
      before { get :show, params: { token: 'foobar' }, format: :json }

      it 'returns not found' do
        expect(response.status).to eq 404
        expect(response.body).to include "Couldn't find ChatApp"
      end
    end
  end

  describe '#create' do
    context 'valid input' do
      it 'creates an app' do
        expect(ChatApp.count).to eq 0
        app_name = Faker::TvShows::SiliconValley.app
        post :create, params: { chat_app: { name: app_name } }
        expect(response.status).to eq 201
        expect(ChatApp.count).to eq 1
      end
    end

    context 'invalid input' do
      it 'does not creates an app' do
        expect(ChatApp.count).to eq 0
        post :create, params: { chat_app: { name: nil } }
        expect(response.status).to eq 422
        expect(response.body).to include "Validation failed: Name can't be blank"
        expect(ChatApp.count).to eq 0
      end
    end
  end
end
