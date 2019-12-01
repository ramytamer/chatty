# frozen_string_literal: true

class CreateChats < ActiveRecord::Migration[5.2]
  def change
    create_table :chats do |t|
      t.string :name
      t.integer :number
      t.references :chat_app, foreign_key: true

      t.timestamps
    end
    add_index :chats, %i[number chat_app_id], unique: true
  end
end
