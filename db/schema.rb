# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2024_07_01_235235) do
  create_table "apps", charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "token"
    t.integer "chats_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["token"], name: "index_apps_on_token"
  end

  create_table "chats", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "app_id"
    t.text "content"
    t.integer 'messages_count'
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ['app_id'], name: 'index_chats_on_application_id'
  end

  create_table "messages", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "message_number"
    t.bigint "chat_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["chat_id"], name: "fk_rails_0f670de7ba"
    t.index ["message_number"], name: "index_messages_on_message_number"
  end

  add_foreign_key 'chats', 'apps'
  add_foreign_key "messages", "chats", on_delete: :cascade
end
