# frozen_string_literal: true

class MessagesController < ApplicationController
  include Paginateable
  include Responseable

  before_action :set_message, only: [:show]
  before_action :validate_body, only: [:create]

  def index
    @messages = Message.for_chat(params[:chat_app_token], params[:chat_number])
                       .paginate(per_page: per_page, page: page)
  end

  def show; end

  def create
    key = "chat_apps.#{params[:chat_app_token]}.chats.#{params[:chat_number]}.messages.number"

    number = Redix.connection.incr(key)

    MessageCreationWorker.perform_async(message_params[:body], number, params[:chat_number], params[:chat_app_token])

    render json: { message_number: number }, status: :created
  end

  private

  def set_message
    @message = Message.for_chat(params[:chat_app_token], params[:chat_number]).by_number(params[:number]).first
  end

  def message_params
    params.require(:message).permit(:body)
  end

  def validate_body
    message = Message.new(body: message_params[:body])
    message.valid?

    return if message.errors[:body].blank?

    render json: { error: "Validation failed: Body #{message.errors[:body].join(', ')}" }, status: 422
  end
end
