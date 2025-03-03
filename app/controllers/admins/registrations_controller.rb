class Admins::RegistrationsController < Devise::RegistrationsController
  before_action :authenticate_admin!

  protected

  def sign_up(resource_name, resource)
    redirect_to new_admin_session_path
  end

  def new
    redirect_to new_admin_session_path, alert: "Admin sign-up is not allowed."
  end

  def create
    redirect_to new_admin_session_path, alert: "Admin sign-up is not allowed."
  end
end
