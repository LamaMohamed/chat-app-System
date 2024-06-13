class ChatsController < ApplicationController
  before_action :set_chat, only: [:show, :update, :destroy]

  def get_chats
    result, status = ChatService.get_chats(params[:app_token])
    render json: result, status: status
  end

  def get_messages_count
    result, status = ChatService.get_messages_count(params[:app_token], params[:chat_number])
    render json: result, status: status
  end

  def post_chat
    result, status = ChatService.post_chat(params[:app_token])
    render json: result, status: status
  end

  def delete_chat
    result, status = ChatService.delete_chat(params[:app_token], params[:chat_number])
    render json: result, status: status
  end

  private

  def set_chat
    @chat = Chat.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "Chat not found with ID: #{params[:id]}"
    render json: { error: "Chat not found" }, status: :not_found
  end

  def chat_params
    params.require(:chat).permit(:chat_number, :app_id)
  end
end
