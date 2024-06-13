class Message < ApplicationRecord
  belongs_to :chat, foreign_key: 'chat_id', primary_key: 'id'

  after_create :increment_messages_count
  after_destroy :decrement_messages_count

  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  index_name Rails.application.class.module_parent_name.underscore
  document_type self.name.downcase

  settings index: { number_of_shards: 1 } do
    mapping dynamic: false do
      indexes :message_number, type: :long
      indexes :chat_id, type: :long
      indexes :content, type: :text, analyzer: 'english'
    end
  end

  def self.search(query)
    __elasticsearch__.search(
      {
        size: 20,
        query: {
          query_string: {
            query: "*#{query}*",
            fields: ['content']
          }
        }
      }
    )
  end

  def as_indexed_json(options = nil)
    as_json(only: [:message_number, :chat_id, :content])
  end

  private

  def increment_messages_count
    Chat.increment_counter(:messages_count, self.chat_id)
    Rails.logger.info "Incremented messages_count for chat_id: #{self.chat_id}"
  end

  def decrement_messages_count
    Chat.decrement_counter(:messages_count, self.chat_id)
    Rails.logger.info "Decremented messages_count for chat_id: #{self.chat_id}"
  end
end
