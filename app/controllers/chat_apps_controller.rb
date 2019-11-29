# frozen_string_literal: true

class ChatAppsController < ApplicationController
  include Paginateable
  include Responseable

  def index
    @chat_apps = ChatApp.paginate(page: page)
  end

  def create
    @chat_app = ChatApp.create!(chat_app_params)
  end

  private

  def chat_app_params
    params.require(:chat_app).permit(:name)
  end
end
