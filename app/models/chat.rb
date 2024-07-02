class Chat < ApplicationRecord
  belongs_to :app, foreign_key: 'app_id', primary_key: 'id'
  has_many :messages, foreign_key: 'chat_id', primary_key: 'id',dependent: :destroy
  

end