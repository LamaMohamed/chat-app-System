class UpdateMessageCount
  include Sidekiq::Worker

  def perform(app_token,chat_number)
    chat = Chat.find_by_chat_number(chat_number)
    new_messages_count = MessageService.get_messages_count(app_token, chat_number)
    chat.update(messages_count: new_messages_count)
  rescue ActiveRecord::RecordNotFound => e
    logger.error "Chat with number #{chat_number} not found: #{e.message}"
  end
end