class ApplicationController < ActionController::Base
  def after_sign_out_path_for(resource_or_scope)
    new_admin_session_path # Redirects to the admin login page
  end
  skip_before_action :verify_authenticity_token
  protect_from_forgery with: :null_session

end
