# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Responseable, type: :controller do
  described_class.tap do |mod|
    controller(ActionController::Base) do
      include mod

      def index; end

      def json_response
        raw_json_response({})
      end

      def status_json_response
        raw_json_response({}, 204)
      end

      def full_json_response
        raw_json_response({ foo: 'bar' }, 205)
      end

      def not_found
        ChatApp.find(2019)
      end

      def record_invalid
        ChatApp.create!
      end
    end
  end

  before do
    routes.draw do
      get 'json_response' => 'anonymous#json_response'
      get 'status_json_response' => 'anonymous#status_json_response'
      get 'full_json_response' => 'anonymous#full_json_response'
      get 'not_found' => 'anonymous#not_found'
      get 'record_invalid' => 'anonymous#record_invalid'
    end
  end

  describe '#raw_json_response' do
    it 'responds to raw_json_response method' do
      expect(subject).to respond_to :raw_json_response
    end

    it 'returns the json with 200 status as default' do
      get :json_response
      expect(response.status).to eq 200
      expect(JSON.parse(response.body).keys).to be_empty
    end

    it 'returns with defined status code' do
      get :status_json_response
      expect(response.status).to eq 204
      expect(JSON.parse(response.body).keys).to be_empty
    end

    it 'returns the json with defined status code' do
      get :full_json_response
      expect(response.status).to eq 205
      expect(JSON.parse(response.body)['foo']).to eq 'bar'
    end
  end

  describe 'ActiveRecord::RecordNotFound' do
    before { get :not_found }

    it 'returns 404 status code' do
      expect(response.status).to eq 404
    end

    it 'returns error json' do
      expect(JSON.parse(response.body)['error']).to eq "Couldn't find ChatApp with 'id'=2019"
    end
  end

  describe 'ActiveRecord::RecordInvalid' do
    before { get :record_invalid }

    it 'returns 422 status code' do
      expect(response.status).to eq 422
    end

    it 'returns error json' do
      expect(JSON.parse(response.body)['error']).to eq "Validation failed: Name can't be blank"
    end
  end
end
