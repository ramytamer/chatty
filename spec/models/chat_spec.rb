# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Chat, type: :model do
  describe 'Validation' do
    before { @chat_app = create(:chat_app) }

    context 'Presence' do
      subject { Chat.new }

      it 'should not be valid' do
        expect(subject.valid?).to be false
      end

      it 'should have error on name' do
        expect(subject).to have(1).error_on(:name)
        expect(subject.errors_on(:name)).to include "can't be blank"
      end

      it 'should have error on number' do
        expect(subject).to have(1).error_on(:number)
        expect(subject.errors_on(:number)).to include "can't be blank"
      end

      it 'should have error on chat_app' do
        expect(subject).to have(2).error_on(:chat_app)
        expect(subject.errors_on(:chat_app)).to include "can't be blank"
        expect(subject.errors_on(:chat_app)).to include 'must exist'
      end
    end

    context 'Uiqueness' do
      subject do
        chat = create(:chat, chat_app: @chat_app)
        build(:chat, number: chat.number, chat_app: @chat_app)
      end

      it 'should not be valid' do
        expect(subject.valid?).to be false
      end

      it 'should have error on number' do
        expect(subject).to have(1).errors_on(:number)
        expect(subject.errors_on(:number)).to include 'has already been taken'
      end
    end
  end
end
