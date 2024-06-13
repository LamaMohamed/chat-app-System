class MessageService
  def self.get_messages(app_token, chat_number)
    cache_key = "messages_get_messages_#{app_token}_#{chat_number}"
    cached_response = $redis.get(cache_key)

    if cached_response
      Rails.logger.info "Cache hit for messages with chat number: #{chat_number}"
      return JSON.parse(cached_response), :ok
    end

    chat = find_chat_by_token_and_number(app_token, chat_number)
    return chat unless chat.is_a?(Chat)

    messages = chat.messages.as_json(only: [:message_number, :content, :created_at, :updated_at])
    $redis.set(cache_key, messages.to_json)
    Rails.logger.info "Cache miss for messages. Cached response for chat number: #{chat_number}"
    return messages, :ok
  end

  def self.post_message(app_token, chat_number, content)
    return { error: "Unsuccessful: cannot accept null message content" }, :bad_request unless content.present?

    chat = find_chat_by_token_and_number(app_token, chat_number)
    return chat unless chat.is_a?(Chat)

    new_message_number = chat.messages.maximum('message_number').to_i + 1
    message = chat.messages.new(message_number: new_message_number, content: content)

    if message.save
      clear_cache(app_token, chat_number, new_message_number)
      Rails.logger.info "Message created with message number: #{new_message_number} for chat number: #{chat_number}"
      return message.as_json(only: [:message_number, :content, :created_at, :updated_at]), :created
    else
      Rails.logger.error "Failed to create message: #{message.errors.full_messages.join(', ')}"
      return message.errors, :unprocessable_entity
    end
  end

  def self.get_message(app_token, chat_number, message_number)
    cache_key = "messages_get_message_#{app_token}_#{chat_number}_#{message_number}"
    cached_response = $redis.get(cache_key)

    if cached_response
      Rails.logger.info "Cache hit for message with chat number: #{chat_number}, and message number: #{message_number}"
      return JSON.parse(cached_response), :ok
    end

    message = find_message_by_token_chat_and_number(app_token, chat_number, message_number)
    return message unless message.is_a?(Message)

    response = message.as_json(only: [:message_number, :content, :created_at, :updated_at])
    $redis.set(cache_key, response.to_json)
    Rails.logger.info "Cache miss for message. Cached response for chat number: #{chat_number}, and message number: #{message_number}"
    return response, :ok
  end

  def self.delete_message(app_token, chat_number, message_number)
    message = find_message_by_token_chat_and_number(app_token, chat_number, message_number)
    return message unless message.is_a?(Message)

    if message.destroy
      clear_cache(app_token, chat_number, message_number)
      Rails.logger.info "Successfully deleted message number: #{message_number} for chat number: #{chat_number}"
      return { message: "Successful: Deleted message number #{message_number}" }, :ok
    else
      Rails.logger.error "Failed to delete message with valid parameters for message number: #{message_number}, chat number: #{chat_number}"
      return { error: "Unsuccessful: Valid parameters but could not delete" }, :unprocessable_entity
    end
  end

  def self.update_message(app_token, chat_number, message_number, content)
    return { error: "Unsuccessful: cannot accept null message content" }, :bad_request unless content.present?

    message = find_message_by_token_chat_and_number(app_token, chat_number, message_number)
    return message unless message.is_a?(Message)

    if message.update(content: content)
      clear_cache(app_token, chat_number, message_number)
      Rails.logger.info "Message updated with message number: #{message_number} for chat number: #{chat_number}"
      return message.as_json(only: [:message_number, :content, :created_at, :updated_at]), :ok
    else
      Rails.logger.error "Failed to update message: #{message.errors.full_messages.join(', ')}"
      return message.errors, :unprocessable_entity
    end
  end

  private

  def self.find_chat_by_token_and_number(app_token, chat_number)
    application = App.find_by_token(app_token)
    return { error: "Invalid application token" }, :not_found unless application

    chat = application.chats.find_by(chat_number: chat_number)
    return { error: "Invalid chat number" }, :not_found unless chat

    chat
  end

  def self.find_message_by_token_chat_and_number(app_token, chat_number, message_number)
    chat = find_chat_by_token_and_number(app_token, chat_number)
    return chat unless chat.is_a?(Chat)

    message = chat.messages.find_by(message_number: message_number)
    return { error: "Invalid message number" }, :not_found unless message

    message
  end

  def self.clear_cache(app_token, chat_number, message_number)
    delete_cache_keys("messages_get_messages_#{app_token}_#{chat_number}")
    delete_cache_keys("messages_get_message_#{app_token}_#{chat_number}_#{message_number}")
    delete_cache_keys("search_#{app_token}_*#{chat_number}*")
  end

  def self.delete_cache_keys(pattern)
    keys_to_delete = $redis.keys(pattern)
    keys_to_delete.each { |key| $redis.del(key) }
  end
end
