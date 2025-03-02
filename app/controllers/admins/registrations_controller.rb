class Admins::RegistrationsController < Devise::RegistrationsController
  def new
    redirect_to new_admin_session_path, alert: "Admin sign-up is not allowed."
  end

  def create
    redirect_to new_admin_session_path, alert: "Admin sign-up is not allowed."
  end
end
