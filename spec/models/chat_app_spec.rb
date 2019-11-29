# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChatApp, type: :model do
  describe 'Validation' do
    context 'Presence' do
      subject { ChatApp.new }

      it 'should not be valid' do
        expect(subject.valid?).to be false
      end

      it 'should have error on name' do
        expect(subject).to have(1).error_on(:name)
        expect(subject.errors_on(:name)).to include "can't be blank"
      end

      it 'should not have errors on token' do
        expect(subject).to have(0).error_on(:token)
      end

      it 'should have error on token if persisted' do
        chat_app = create(:chat_app)
        chat_app.token = nil
        expect(chat_app.valid?).to be false
        expect(chat_app).to have(1).error_on(:token)
        expect(chat_app.errors_on(:token)).to include "can't be blank"
      end
    end

    context 'Uiqueness' do
      subject do
        app = create(:chat_app)
        build(:chat_app, token: app.token)
      end

      it 'should not be valid' do
        expect(subject.valid?).to be false
      end

      it 'should have error on token' do
        expect(subject).to have(1).errors_on(:token)
        expect(subject.errors_on(:token)).to include 'has already been taken'
      end
    end
  end

  describe 'before_create' do
    describe 'set_token' do
      subject { build(:chat_app, token: nil) }

      it 'should call the set_token method' do
        expect(subject).to receive(:set_token)
        subject.save
      end
    end
  end

  describe '#set_token' do
    context 'setting token if nil' do
      subject { build(:chat_app, token: nil) }

      it 'should set the token if nil' do
        expect(subject.token).to be nil
        subject.set_token
        expect(subject.token).not_to be nil
      end
    end

    context 'do not do anything if it is set' do
      subject { build(:chat_app) }

      it 'should set the token if nil' do
        old_token = subject.token
        subject.set_token
        expect(subject.token).to eq old_token
      end
    end
  end
end
