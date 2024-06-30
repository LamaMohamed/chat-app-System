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

ActiveRecord::Schema[7.1].define(version: 2024_6_30_002941) do
    create_table "apps", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
        t.string "name"
        t.string "token"
        t.integer "chats_count", default: 0
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.index ["token"], name: "index_apps_on_token"
      end
    
      create_table "chats", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
        t.integer "chat_number"
        t.bigint "app_id"
        t.integer "messages_count", default: 0
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.index ["app_id"], name: "fk_rails_de65013ee8"
        t.index ["chat_number"], name: "index_chats_on_chat_number"
      end
    
      create_table "messages", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
        t.bigint "chat_id"
        t.integer "message_number"
        t.text "content"
        t.datetime "created_at", null: false
        t.datetime "updated_at", null: false
        t.index ["chat_id"], name: "fk_rails_0f670de7ba"
        t.index ["message_number"], name: "index_messages_on_message_number"
      end
    
      add_foreign_key "chats", "apps", on_delete: :cascade
      add_foreign_key "messages", "chats", on_delete: :cascade
end
