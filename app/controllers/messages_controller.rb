class MessagesController < ApplicationController
  before_action :set_application_and_chat, only: [:get_messages, :post_message, :get_message, :delete_message, :update_message]
  before_action :set_message, only: [:get_message, :delete_message, :update_message]

  def get_messages
    result, status = MessageService.get_messages(params[:app_token], params[:chat_number])
    render json: result, status: status
  end

  def post_message
    content_to_use = request.body.read
    result, status = MessageService.post_message(params[:app_token], params[:chat_number], content_to_use)
    render json: result, status: status
  end

  def get_message
    result, status = MessageService.get_message(params[:app_token], params[:chat_number], params[:message_number])
    render json: result, status: status
  end

  def delete_message
    result, status = MessageService.delete_message(params[:app_token], params[:chat_number], params[:message_number])
    render json: result, status: status
  end

  def update_message
    content_to_use = request.body.read
    result, status = MessageService.update_message(params[:app_token], params[:chat_number], params[:message_number], content_to_use)
    render json: result, status: status
  end

  def search
    result, status = MessageService.search(params[:app_token], params[:chat_number], params[:query])
    render json: result, status: status
  end

  private

  def set_application_and_chat
    @application = App.find_by_token(params[:app_token])
    return render json: { error: "Invalid application token" }, status: :not_found unless @application

    @chat = @application.chats.find_by_chat_number(params[:chat_number])
    return render json: { error: "Invalid chat number" }, status: :not_found unless @chat
  end

  def set_message
    @message = @chat.messages.find_by(message_number: params[:message_number])
    return render json: { error: "Invalid message number" }, status: :not_found unless @message
  end
end
