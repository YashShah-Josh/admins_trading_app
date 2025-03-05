class ApplicationController < ActionController::API

  before_action :authenticate_user!
  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path # Redirects to the admin login page
  end

  def authenticate_user!
    token = request.headers["Authorization"]&.split(" ")&.last
    return render json: { error: "Unauthorized" }, status: :unauthorized unless token

    begin
      decoded_token = JWT.decode(token, Rails.application.secrets.secret_key_base, true, algorithm: "HS256")
      user_id = decoded_token[0]["user_id"]
      @current_user = User.find_by(id: user_id)

      return render json: { error: "Invalid token" }, status: :unauthorized unless @current_user
    rescue JWT::DecodeError
      render json: { error: "Invalid token" }, status: :unauthorized
    end
  end

  def current_user
    @current_user
  end
end
