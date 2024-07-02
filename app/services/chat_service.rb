class ChatService
  def self.get_chats(app_token)
    cache_key = "chats_get_chats_#{app_token}"
    cached_response = $redis.get(cache_key)

    if cached_response
      Rails.logger.info "Cache hit for chats with token: #{app_token}"
      return cached_response, :ok
    end

    app = App.find_by_token(app_token)
    unless app
      Rails.logger.error "Invalid token: #{app_token}"
      return { error: "Unsuccessful: Invalid token #{app_token}" }, :not_found
    end

    to_cache = app.chats.as_json(only: [:chat_number, :created_at])
    $redis.set(cache_key, to_cache)
    Rails.logger.info "Cache miss for chats. Cached response for token: #{app_token}"
    return to_cache, :ok
  end

  def self.get_messages_count(app_token, chat_number)
    cache_key = "chats_get_messages_count_#{app_token}_#{chat_number}"
    cached_response = $redis.get(cache_key)

    if cached_response
      Rails.logger.info "Cache hit for messages count with token: #{app_token} and chat number: #{chat_number}"
      return { messages_count: cached_response.to_i }, :ok
    end

    application = App.find_by_token(app_token)
    unless application
      Rails.logger.error "Invalid token: #{app_token}"
      return { error: "Unsuccessful: Invalid token #{app_token}" }, :not_found
    end

    chat = application.chats.find_by_chat_number(chat_number)
    unless chat
      Rails.logger.error "Invalid chat number: #{chat_number}"
      return { error: "Unsuccessful: Invalid chat number #{chat_number}" }, :not_found
    end

    to_cache = chat.messages_count
    $redis.set(cache_key, to_cache)
    Rails.logger.info "Cache miss for messages count. Cached response for token: #{app_token} and chat number: #{chat_number}"
    return { messages_count: to_cache }, :ok
  end

  def self.post_chat(app_token)
    application = App.find_by_token(app_token)
    unless application
      Rails.logger.error "Invalid token: #{app_token}"
      return { error: "Unsuccessful: Invalid token #{app_token}" }, :not_found
    end

    new_chat_number = get_new_chat_number params[:token]
    increment_chats_count params[:token]
    chat = Chat.new({ app_token: params[:token], chat_number: new_chat_number, messages_count: 0 }) 

    if chat.save
      Rails.logger.info "Chat created with chat number: #{new_chat_number} for token: #{app_token}"
      return chat.as_json(only: [:new_chat_number, :created_at]), :ok
    else
      Rails.logger.error "Failed to create chat: #{chat.errors.full_messages.join(', ')}"
      return chat.errors, :unprocessable_entity
    end
  end

  def self.delete_chat(app_token, chat_number)
    application = App.find_by_token(app_token)
    unless application
      Rails.logger.error "Invalid token: #{app_token}"
      return { error: "Unsuccessful: Invalid token #{app_token}" }, :not_found
    end

    chat = Chat.find_by(app_token: application.token, chat_number: chat_number)
    unless chat
      Rails.logger.error "Invalid chat number: #{chat_number}"
      return { error: "Unsuccessful: Invalid chat number #{chat_number}" }, :not_found
    end

    if chat.destroy
      delete_cache_keys("*#{app_token}_*#{chat_number}*")
      delete_cache_keys("apps_get_chats_count_#{app_token}")
      delete_cache_keys("search_#{app_token}_*#{chat_number}*")
      Rails.logger.info "Successfully deleted chat number: #{chat_number}"
      return { message: "Successful: Deleted chat number #{chat_number}" }, :ok
    else
      Rails.logger.error "Failed to delete chat with valid parameters for chat number: #{chat_number}"
      return { error: "Unsuccessful: Valid parameters but could not delete" }, :unprocessable_entity
    end
  end

  def get_new_chat_number(app_token)
    $redis.incr("chat_number_counter$#{app_token}")
  end

  def increment_chats_count(app_token)
    $redis.incr("chats_count$#{app_token}")
  end

  def decrement_chats_count(app_token)
    $redis.decr("chats_count$#{app_token}")
  end

  private

  def self.delete_cache_keys(pattern)
    keys_to_delete = $redis.keys(pattern)
    keys_to_delete.each { |key| $redis.del(key) }
  end
end
