# Chat System API

## Setup

1. Clone the repository.
2. Run `bundle install` to install dependencies.
3. Run `rails db:create db:migrate` to set up the database.
4. Run `docker-compose up` to start the services.

## Endpoints

### Applications routes

- post '/applications', to: 'apps#get_token'
- get '/applications/:app_token/chats/count'
- delete '/applications/:app_token'

### Chats routes

- post '/applications/:app_token/chats'
- get '/applications/:app_token/chats'
- get '/applications/:app_token/chats/:chat_number/messages/count', to: 'chats#get_messages_count'
- delete '/applications/:app_token/chats/:chat_number'

### Messages routes

- post '/applications/:app_token/chats/:chat_number/messages', to: 'messages#post_message'
- get '/applications/:app_token/chats/:chat_number/messages', to: 'messages#get_messages'
- get '/applications/:app_token/chats/:chat_number/messages/:message_number'
- put '/applications/:app_token/chats/:chat_number/messages/:message_number'
- delete '/applications/:app_token/chats/:chat_number/messages/:message_number'

### Search route

- get '/applications/:app_token/chats/:chat_number/search'
