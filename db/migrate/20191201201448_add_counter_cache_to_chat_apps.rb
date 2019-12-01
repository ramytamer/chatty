# frozen_string_literal: true

class AddCounterCacheToChatApps < ActiveRecord::Migration[5.2]
  def change
    add_column :chat_apps, :chats_count, :integer

    ChatApp.find_each do |chat_app|
      ChatApp.reset_counters(chat_app.id, :chats)
    end
  end
end
