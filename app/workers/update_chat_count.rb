class UpdateChatCount
    include Sidekiq::Worker
  
    def perform
      Chat.find_each do |chat|
        UpdateMessageCount.perform_async(chat.id)
      end
    rescue => e
      logger.error "Error scheduling message count updates: #{e.message}"
    end
  end