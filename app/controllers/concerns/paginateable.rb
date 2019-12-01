# frozen_string_literal: true

module Paginateable
  extend ActiveSupport::Concern

  included do
  end

  def page
    params[:page].present? && params[:page].to_i.positive? ? params[:page].to_i : 1
  end

  def per_page
    return params[:per_page].to_i if params[:per_page].present? && params[:per_page].to_i.positive?

    Rails.configuration.default_pagination_per_page
  end
end
