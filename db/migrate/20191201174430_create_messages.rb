# frozen_string_literal: true

class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :number
      t.references :chat, foreign_key: true

      t.timestamps
    end
    add_index :messages, %i[number chat_id], unique: true
  end
end
