class AppsController < ApplicationController

  def get_token
    result, status = AppService.create_token(params[:name])
    render json: result, status: status
  end

  def delete_app
    result, status = AppService.delete_app(params[:app_token])
    render json: result, status: status
  end

  def get_chats_count
    result, status = AppService.get_chats_count(params[:app_token])
    render json: result, status: status
  end

  def get_all
    result, status = AppService.get_all
    render json: result, status: status
  end  

  private

  def set_app
    @app = App.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    Rails.logger.error "App not found with ID: #{params[:id]}"
    render json: { error: "App not found" }, status: :not_found
  end

  def app_params
    params.require(:app).permit(:name, :app_token)
  end
end
