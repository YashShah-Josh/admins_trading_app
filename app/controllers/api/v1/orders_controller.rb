class Api::V1::OrdersController < ApplicationController
    before_action :authenticate_user!
  
    # Buy Stocks
    def buy
      user = current_user
      stock = Stock.find_by(id: params[:stock_id])
      quantity = params[:quantity].to_i
      stock_price = stock.current_price
  
      # Total amount calculation
      total_amount = stock_price * quantity
      brokerage = total_amount * 0.02  # 2% Brokerage
      taxes = total_amount * 0.18      # 18% Taxes
      final_amount = total_amount + brokerage + taxes
  
      # Check if the user has enough balance
      if user.balance < final_amount
        return render json: { error: "Insufficient balance" }, status: :unprocessable_entity
      end
  
      # Check if enough stock is available
      if stock.quantity < quantity
        return render json: { error: "Not enough stock available" }, status: :unprocessable_entity
      end
  
      ActiveRecord::Base.transaction do
        # Deduct balance from user
        user.update!(balance: user.balance - final_amount)
  
        # Create Order
        order = Order.create!(
          user_id: user.id,
          stock_id: stock.id,
          price: stock_price,
          quantity: quantity,
          status: "completed"
        )
  
        # Update user_stocks (add stock to user or update avg price)
        user_stock = UserStock.find_or_initialize_by(user_id: user.id, stock_id: stock.id)
        old_quantity = user_stock.quantity || 0
        old_purchased_price = user_stock.purchased_price || 0
  
        total_quantity = old_quantity + quantity
        new_avg_price = ((old_quantity * old_purchased_price) + (quantity * stock_price)) / total_quantity
  
        user_stock.update!(
          quantity: total_quantity,
          purchased_price: new_avg_price,
          current_price: stock_price
        )
  
        # Reduce available stock quantity
        stock.update!(quantity: stock.quantity - quantity)
  
        # Create Transaction
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
  
      render json: { message: "Stock purchased successfully" }, status: :ok
    end
  
    # Sell Stocks
    def sell
      user = current_user
      stock = Stock.find_by(id: params[:stock_id])
      quantity = params[:quantity].to_i
      stock_price = stock.current_price
  
      # Find user's stock holdings
      user_stock = UserStock.find_by(user_id: user.id, stock_id: stock.id)
  
      # Ensure user has enough stock
      if user_stock.nil? || user_stock.quantity < quantity
        return render json: { error: "Not enough stock to sell" }, status: :unprocessable_entity
      end
  
      # Total amount calculation
      total_amount = stock_price * quantity
      brokerage = total_amount * 0.02  # 2% Brokerage
      taxes = total_amount * 0.18      # 18% Taxes
      final_amount = total_amount - brokerage - taxes
  
      ActiveRecord::Base.transaction do
        # Deduct stock from user
        new_quantity = user_stock.quantity - quantity
        if new_quantity == 0
          user_stock.destroy!
        else
          user_stock.update!(quantity: new_quantity)
        end
  
        # Create Order
        order = Order.create!(
          user_id: user.id,
          stock_id: stock.id,
          price: stock_price,
          quantity: quantity,
          status: "completed"
        )
  
        # Increase stock quantity
        stock.update!(quantity: stock.quantity + quantity)
  
        # Add balance to user
        user.update!(balance: user.balance + final_amount)
  
        # Create Transaction
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
  
      render json: { message: "Stock sold successfully" }, status: :ok
    end
  end
  