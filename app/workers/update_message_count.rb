class UpdateMessageCount
  include Sidekiq::Worker

  def perform(chat_id)
    chat = Chat.find(chat_id)
    new_messages_count = chat.messages.where('created_at > ?', 1.hour.ago).count
    chat.update(messages_count: new_messages_count)
  rescue ActiveRecord::RecordNotFound => e
    logger.error "Chat with ID #{chat_id} not found: #{e.message}"
  end
end