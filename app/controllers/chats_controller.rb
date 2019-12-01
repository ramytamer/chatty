# frozen_string_literal: true

class ChatsController < ApplicationController
  include Paginateable
  include Responseable

  before_action :set_chat, only: [:show]
  before_action :validate_name, only: [:create]

  def index
    @chats = Chat.by_chat_app_token(params[:chat_app_token]).paginate(per_page: per_page, page: page)
  end

  def show; end

  def create
    key = "chat_apps.#{params[:chat_app_token]}.chats.number"

    number = Redix.connection.incr(key)

    ChatCreationWorker.perform_async(chat_params[:name], number, params[:chat_app_token])

    render json: { chat_number: number }, status: :created
  end

  private

  def set_chat
    @chat = Chat.by_chat_app_token(params[:chat_app_token]).by_number(params[:number]).first
  end

  def chat_params
    params.require(:chat).permit(:name)
  end

  def validate_name
    chat = Chat.new(name: chat_params[:name])
    chat.valid?

    return if chat.errors[:name].blank?

    render json: { error: "Validation failed: Name #{chat.errors[:name].join(', ')}" }, status: 422
  end
end
