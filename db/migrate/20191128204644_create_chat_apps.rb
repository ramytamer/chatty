# frozen_string_literal: true

class CreateChatApps < ActiveRecord::Migration[5.2]
  def change
    create_table :chat_apps do |t|
      t.string :name
      t.string :token

      t.timestamps
    end
    add_index :chat_apps, :token, unique: true
  end
end
