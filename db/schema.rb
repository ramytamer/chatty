# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20_191_201_035_013) do

  create_table 'chat_apps', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'name'
    t.string 'token'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['token'], name: 'index_chat_apps_on_token', unique: true
  end

  create_table 'chats', options: 'ENGINE=InnoDB DEFAULT CHARSET=utf8', force: :cascade do |t|
    t.string 'name'
    t.integer 'number'
    t.bigint 'chat_app_id'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['chat_app_id'], name: 'index_chats_on_chat_app_id'
    t.index %w[number chat_app_id], name: 'index_chats_on_number_and_chat_app_id', unique: true
  end

  add_foreign_key 'chats', 'chat_apps'
end
