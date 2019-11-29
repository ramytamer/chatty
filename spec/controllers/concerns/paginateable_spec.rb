# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Paginateable, type: :controller do
  described_class.tap do |mod|
    controller(ActionController::Base) do
      include mod

      def index; end
    end
  end

  describe '#page' do
    it 'responds to page method' do
      expect(subject).to respond_to :page
    end

    it 'returns 1 as default value for page param' do
      expect(subject.page).to eq 1
    end

    it 'returns 1 as if invalid page param value' do
      subject.params['page'] = 'invalid'
      expect(subject.page).to eq 1
    end

    it 'returns correct page value' do
      subject.params['page'] = '5'
      expect(subject.page).to eq 5
    end
  end
end
