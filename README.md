# Chat System API
Chat system allow creating new applications where each application will have token(generated by the system) and a name. Each application can have many chats.

- Ruby 3.3.3
- Database: Mysql 
- Caching: Redis
- Jobs: Sidekiq
- Containerization: Docker

## Setup

1. Clone the repository.
2. Run `bundle install` to install dependencies.
3. Run `rails db:create db:migrate` to set up the database.
4. Run `docker-compose up -d --build` to start the services.

## Endpoints

### Applications routes

- post '/applications', to: 'apps#get_token'
- get '/applications', to: 'get_all'
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
