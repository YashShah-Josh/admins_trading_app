class Api::V1::OrdersController < ApplicationController
  before_action :authenticate_request!

  # Buy Stocks
  def buy
    user = current_user
    stock = Stock.find_by(id: params[:stock_id])
    quantity = params[:quantity].to_i
    stock_price = stock&.current_price

    Rails.logger.info "Stock: #{stock.inspect}" # Log stock details
    Rails.logger.info "User: #{user.inspect}"   # Log user details

    return render json: { error: "Stock not found" }, status: :unprocessable_entity if stock.nil?

    total_amount = stock_price * quantity
    brokerage = total_amount * 0.02  # 2% Brokerage
    taxes = brokerage * 0.18      # 18% Taxes
    final_amount = total_amount + brokerage + taxes

    if user.balance < final_amount
      Rails.logger.error "Insufficient balance: User Balance: #{user.balance}, Required: #{final_amount}"
      return render json: { error: "Insufficient balance" }, status: :unprocessable_entity
    end

    if stock.quantity < quantity
      Rails.logger.error "Not enough stock: Available: #{stock.quantity}, Requested: #{quantity}"
      return render json: { error: "Not enough stock available" }, status: :unprocessable_entity
    end

    order = nil # Initialize order before transaction block

    ActiveRecord::Base.transaction do
      user.update!(balance: user.balance - final_amount)

      order = Order.create!(
        user_id: user.id,
        stock_id: stock.id,
        price: stock_price,
        quantity: quantity,
        status: "completed",
      )

      Rails.logger.info "Order created: #{order.inspect}"

      user_stock = UserStock.find_or_initialize_by(user_id: user.id, stock_id: stock.id)
      old_quantity = user_stock.quantity || 0
      old_purchased_price = user_stock.purchased_price || 0

      total_quantity = old_quantity + quantity
      new_avg_price = ((old_quantity * old_purchased_price) + (quantity * stock_price)) / total_quantity

      user_stock.update!(
        quantity: total_quantity,
        purchased_price: new_avg_price,
        current_price: stock_price,
      )

      Rails.logger.info "UserStock updated: #{user_stock.inspect}"

      stock.update!(quantity: stock.quantity - quantity)

      Transaction.create!(
        order_id: order.id,
        user_id: user.id,
        transaction_type: "buy",
        amount: total_amount,
        brokerage: brokerage,
        taxes: taxes,
        total_amount: final_amount,
        transaction_date: Time.current
      )
    end
    render json: { message: "Stock purchased successfully", order: order }, status: :ok
  end

  # Sell Stocks
  def sell
    user = current_user
    stock = Stock.find_by(id: params[:stock_id])
    quantity = params[:quantity].to_i

    return render json: { error: "Stock not found" }, status: :not_found unless stock
    return render json: { error: "Invalid quantity" }, status: :unprocessable_entity if quantity <= 0

    user_stock = UserStock.find_by(user_id: user.id, stock_id: stock.id)
    return render json: { error: "You don't own this stock" }, status: :unprocessable_entity if user_stock.nil? || user_stock.quantity < quantity

    stock_price = stock.current_price
    total_amount = stock_price * quantity
    brokerage = total_amount * 0.02  # 2% Brokerage
    taxes = brokerage * 0.18      # 18% Taxes
    final_amount = total_amount - brokerage - taxes

    order = nil

    ActiveRecord::Base.transaction do
      new_quantity = user_stock.quantity - quantity
      if new_quantity.zero?
        user_stock.update!(quantity: 0)
      else
        user_stock.update!(quantity: new_quantity)
      end

      order = Order.create!(
        user_id: user.id,
        stock_id: stock.id,
        price: stock_price,
        quantity: quantity,
        status: "completed",
      )

      user.update!(balance: user.balance + final_amount)

      Transaction.create!(
        order_id: order.id,
        user_id: user.id,
        transaction_type: "sell",
        amount: total_amount,
        brokerage: brokerage,
        taxes: taxes,
        total_amount: final_amount,
        transaction_date: Time.current
      )
    end

    render json: { message: "Stock sold successfully", order: order }, status: :ok
  rescue => e
    Rails.logger.error "Stock sell failed: #{e.message}"
    render json: { error: "Stock sale failed: #{e.message}" }, status: :unprocessable_entity
  end

  private

  def authenticate_request!
    header = request.headers["Authorization"]
    token = header.split(" ").last if header.present?

    return render json: { error: "Token is missing" }, status: :unauthorized if token.blank?

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
end
