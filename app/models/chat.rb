class Chat < ApplicationRecord
  belongs_to :app, foreign_key: 'app_id', primary_key: 'id'
  has_many :messages, foreign_key: 'chat_id', primary_key: 'id',dependent: :destroy

  after_create :increment_chats_count
  after_destroy :decrement_chats_count

  private

  def increment_chats_count
    App.increment_counter(:chats_count, self.app_id)
    Rails.logger.info "Incremented chats_count for app_id: #{self.app_id}"
  end

  def decrement_chats_count
    App.decrement_counter(:chats_count, self.app_id)
    Rails.logger.info "Decremented chats_count for app_id: #{self.app_id}"
  end
end