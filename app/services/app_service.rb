class AppService
  def self.create_token(name)
    return { error: "Unsuccessful: Invalid app name" }, :bad_request unless name.present?

    new_token = SecureRandom.hex(16)
    app = App.new(name: name, token: new_token)
    if app.save
      Rails.logger.info "App created with name: #{name}"
      return app.as_json(only: [:token, :name, :created_at]), :ok
    else
      Rails.logger.error "Failed to create app: #{app.errors.full_messages.join(', ')}"
      return app.errors, :unprocessable_entity
    end
  end

  def self.delete_app(app_token)
    application = App.find_by_token(app_token)
    return { error: "Unsuccessful: Invalid token #{app_token}" }, :not_found unless application

    if application.destroy
      keys_to_delete = $redis.keys("*#{app_token}*")
      keys_to_delete.each { |key| $redis.del(key) }
      Rails.logger.info "Successfully deleted app with token: #{app_token}"
      return { message: "Successful: Deleted #{app_token}" }, :ok
    else
      Rails.logger.error "Unsuccessful: Could not delete app"
      return { error: "Unsuccessful: Could not delete" }, :unprocessable_entity
    end
  end

  def self.get_chats_count(app_token)
    cache_key = "apps_get_chats_count_#{app_token}"
    cached_response = $redis.get(cache_key)

    if cached_response
      Rails.logger.info "Cache hit for chats count with token: #{app_token}"
      return { chats_count: cached_response.to_i }, :ok
    end

    application = App.find_by_token(app_token)
    return { error: "Unsuccessful: Invalid token #{app_token}" }, :not_found unless application

    to_cache = application.chats_count
    $redis.set(cache_key, to_cache)
    Rails.logger.info "Cache miss for chats count. Cached response for token: #{app_token}"
    return { chats_count: to_cache }, :ok
  end

  def self.get_all
    all_apps = App.all
    return all_apps.as_json, :ok
  end
end
