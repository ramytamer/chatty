# frozen_string_literal: true

class ChatsController < ApplicationController
  include Paginateable
  include Responseable

  before_action :set_chat_app, except: [:create]
  before_action :validate_name, only: [:create]

  def index
    @chats = Chat.where(chat_app_id: @chat_app.id).paginate(per_page: per_page, page: page)
  end

  def show
    @chat = Chat.find_by!(number: params[:number], chat_app_id: @chat_app.id)
  end

  def create
    key = "chat_apps.#{params[:chat_app_token]}.chats.number"

    number = Redix.connection.incr(key)

    ChatCreationWorker.perform_async(chat_params[:name], number, params[:chat_app_token])

    render json: { chat_number: number }, status: :created
  end

  private

  def set_chat_app
    @chat_app = ChatApp.find_by!(token: params[:chat_app_token])
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
