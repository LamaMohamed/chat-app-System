class CreateMessages < ActiveRecord::Migration[7.1]
  def change
    create_table :messages do |t|
      t.bigint :message_number
      t.bigint :chat_id
      t.text :content

      t.timestamps
    end

    add_index :messages, :message_number
    add_foreign_key :messages, :chats, on_delete: :cascade
  end
end
