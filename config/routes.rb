Rails.application.routes.draw do

  # Applications routes
  post '/applications', to: 'apps#get_token', as: 'create_application'
  get '/applications/:app_token/chats/count', to: 'apps#get_chats_count', as: 'chats_count'
  delete '/applications/:app_token', to: 'apps#delete_app', as: 'delete_application'

  # Chats routes
  post '/applications/:app_token/chats', to: 'chats#post_chat', as: 'create_chat'
  get '/applications/:app_token/chats', to: 'chats#get_chats', as: 'get_chats'
  get '/applications/:app_token/chats/:chat_number/messages/count', to: 'chats#get_messages_count', as: 'messages_count'
  delete '/applications/:app_token/chats/:chat_number', to: 'chats#delete_chat', as: 'delete_chat'

  # Messages routes
  post '/applications/:app_token/chats/:chat_number/messages', to: 'messages#post_message', as: 'create_message'
  get '/applications/:app_token/chats/:chat_number/messages', to: 'messages#get_messages', as: 'get_messages'
  get '/applications/:app_token/chats/:chat_number/messages/:message_number', to: 'messages#get_message', as: 'get_message'
  put '/applications/:app_token/chats/:chat_number/messages/:message_number', to: 'messages#update_message', as: 'update_message'
  delete '/applications/:app_token/chats/:chat_number/messages/:message_number', to: 'messages#delete_message', as: 'delete_message'

  # Search route
  get '/applications/:app_token/chats/:chat_number/search', to: 'message_search#search', as: 'search_messages'

  # Catch-all route to handle 404 errors
  get '*path' => redirect('/')

end
