require 'jwt'

class Api::V1::UsersController < ActionController::API
  # POST /api/v1/users/login
  def login
    user = User.find_by(email: params[:user][:email])

    if user && user.valid_password?(params[:user][:password])
      token = generate_jwt(user) # Generate JWT token
      render json: { message: "Login successful", token: token, data: user_data(user) }, status: :ok
    else
      render json: { error: "Invalid email or password" }, status: :unauthorized
    end
  end

  # POST /api/v1/users/register
  def register
    user = User.new(user_params)

    if user.save
      token = generate_jwt(user) # Generate JWT token on registration
      render json: { message: "User registered successfully", token: token, data: user_data(user) }, status: :created
    else
      render json: { error: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  # Strong parameters
  def user_params
    params.require(:user).permit(:name, :email, :password, :phone, :address, :pan, :password_confirmation).merge(balance: 0)
  end

  # Generate JWT token
  def generate_jwt(user)
    payload = { user_id: user.id, exp: 24.hours.from_now.to_i } # Token expires in 24 hours
    JWT.encode(payload, Rails.application.credentials.jwt_secret, 'HS256')
  end

  # User response data
  def user_data(user)
    {
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      address: user.address,
      pan: user.pan,
      balance: user.balance
    }
  end
end
