# frozen_string_literal: true

module Paginateable
  extend ActiveSupport::Concern

  included do
  end

  def page
    params[:page].present? && params[:page].to_i.positive? ? params[:page].to_i : 1
  end
end
