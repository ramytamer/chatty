# frozen_string_literal: true

module Paginated
  extend ActiveSupport::Concern

  included do
    scope :paginate, ->(per_page: 25, page: 1) { limit(per_page).offset(per_page * page - per_page) }
  end
end
