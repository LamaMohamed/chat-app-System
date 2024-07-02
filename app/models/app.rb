class App < ApplicationRecord
  has_many :chats, foreign_key: 'app_id', primary_key: 'id', dependent: :destroy
  validates_presence_of :name, :chats_count
end
