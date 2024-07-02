class UpdateChatCount
    include Sidekiq::Worker
  
    def perform(app_token)
      application = App.find_by_token(app_token)
      new_chat_count = ChatService.get_chats_count(app_token)
      application.update(chats_count: new_chat_count)
    rescue ActiveRecord::RecordNotFound => e
      logger.error "App with ID  #{application} not found: #{e.message}"
    end
  end