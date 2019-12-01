# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'Validation' do
    before { @chat = create(:chat) }

    context 'Presence' do
      subject { Message.new }

      it 'should not be valid' do
        expect(subject.valid?).to be false
      end

      it 'should have error on body' do
        expect(subject).to have(1).error_on(:body)
        expect(subject.errors_on(:body)).to include "can't be blank"
      end

      it 'should have error on number' do
        expect(subject).to have(1).error_on(:number)
        expect(subject.errors_on(:number)).to include "can't be blank"
      end

      it 'should have error on chat' do
        expect(subject).to have(2).error_on(:chat)
        expect(subject.errors_on(:chat)).to include "can't be blank"
        expect(subject.errors_on(:chat)).to include 'must exist'
      end
    end

    context 'Uiqueness' do
      subject do
        message = create(:message, chat: @chat)
        build(:message, number: message.number, chat: @chat)
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
