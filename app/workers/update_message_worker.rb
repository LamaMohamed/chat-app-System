class UpdateMessageWorker
    include Sidekiq::Worker
  
    def perform(message_id, new_content)
      message = Message.find(message_id)
      message.update(content: new_content)
    end
  end