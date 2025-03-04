class Api::V1::StocksController < ApplicationController
  before_action :authenticate_request!

  def index
    stocks = Stock.select(:id, :symbol, :company_name, :current_price, :price_change)
    user_stocks = @current_user ? @current_user.user_stocks.includes(:stock) : []
    index_values = {
      bank_nifty: 45123.45,
      nifty: 21785.30,
      fin_nifty: 20678.65,
    }

    render json: {
             stocks: stocks,
             user_stocks: user_stocks.map { |us| format_user_stock(us) },
             index_values: index_values,
           }
  end

  private

  def authenticate_request!
    header = request.headers["Authorization"]
    token = header.split(" ").last if header.present?
  
    if token.blank?
      render json: { error: "Token is missing" }, status: :unauthorized
      return
    end
  
    begin
      decoded_token = JWT.decode(token, Rails.application.credentials.jwt_secret, true, { algorithm: "HS256" }).first
      @current_user = User.find(decoded_token["user_id"])
    rescue JWT::ExpiredSignature
      render json: { error: "Token has expired" }, status: :unauthorized
    rescue JWT::DecodeError
      render json: { error: "Invalid token" }, status: :unauthorized
    rescue ActiveRecord::RecordNotFound
      render json: { error: "User not found" }, status: :unauthorized
    end
  end
  

  def format_user_stock(user_stock)
    {
      stock_id: user_stock.stock_id,
      symbol: user_stock.stock.symbol,
      quantity: user_stock.quantity,
      purchased_price: user_stock.purchased_price,
      current_price: user_stock.current_price,
    }
  end
end
