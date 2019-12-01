# frozen_string_literal: true

class ChatsController < ApplicationController
  include Paginateable
  include Responseable

  before_action :set_chat_app

  def index
    @chats = Chat.where(chat_app_id: @chat_app.id).paginate(per_page: per_page, page: page)
  end

  def show
    @chat = Chat.find_by!(number: params[:number], chat_app_id: @chat_app.id)
  end

  def create
    # @chat = @chat_app.chats.create!(chat_params)

    # head :created
  end

  private

  def set_chat_app
    @chat_app = ChatApp.find_by!(token: params[:chat_app_token])
  end

  def chat_params
    params.require(:chat).permit(:name)
  end
end
