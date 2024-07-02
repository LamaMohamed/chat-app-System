class CreateChats < ActiveRecord::Migration[7.1]
  def change
    create_table :chats do |t|
      t.integer "chat_number"
      t.bigint "app_id"
      t.integer "messages_count", default: 0
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["app_id"], name: "fk_rails_de65013ee8"
      t.index ["chat_number"], name: "index_chats_on_chat_number"
    end
    add_foreign_key :chats, :apps, on_delete: :cascade
  end
end
