# frozen_string_literal: true

class ChatAppsController < ApplicationController
  include Paginateable
  include Responseable

  def index
    @chat_apps = ChatApp.paginate(per_page: per_page, page: page)
  end

  def show
    @chat_app = ChatApp.find_by!(token: params[:token])
  end

  def create
    @chat_app = ChatApp.create!(chat_app_params)
    head :created
  end

  private

  def chat_app_params
    params.require(:chat_app).permit(:name)
  end
end
