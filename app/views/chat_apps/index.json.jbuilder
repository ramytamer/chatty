# frozen_string_literal: true

json.array! @chat_apps, partial: 'chat_apps/chat_app', as: :chat_app
