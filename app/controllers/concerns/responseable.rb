# frozen_string_literal: true

module Responseable
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |e|
      raw_json_response({ error: e.message }, :not_found)
    end

    rescue_from ActiveRecord::RecordInvalid do |e|
      raw_json_response({ error: e.message }, :unprocessable_entity)
    end
  end

  def raw_json_response(response, status = 200)
    render json: response, status: status
  end
end
