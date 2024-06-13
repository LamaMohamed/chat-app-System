class App < ApplicationRecord
  has_many :chats, foreign_key: 'app_id', primary_key: 'id', dependent: :destroy
end
