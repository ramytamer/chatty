# frozen_string_literal: true

class AddCounterCacheToChats < ActiveRecord::Migration[5.2]
  def change
    add_column :chats, :messages_count, :integer

    Chat.find_each do |chat|
      Chat.reset_counters(chat.id, :messages)
    end
  end
end
