# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :chat_apps, except: %i[destroy update], param: :token, defaults: { format: :json } do
    resources :chats, except: %i[destroy update], param: :number, defaults: { format: :json }
  end
end
