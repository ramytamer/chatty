# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :chat_apps, except: [:destroy], param: :token, defaults: { format: :json }
end
