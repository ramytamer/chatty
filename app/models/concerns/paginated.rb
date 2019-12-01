# frozen_string_literal: true

module Paginated
  extend ActiveSupport::Concern

  included do
    scope :paginate, lambda { |per_page: Rails.configuration.default_pagination_per_page, page: 1|
      limit(per_page).offset(per_page * page - per_page)
    }
  end
end
