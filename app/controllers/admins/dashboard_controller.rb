module Admins
  class DashboardController < ApplicationController
    layout "admin"

    before_action :authenticate_admin!  # Ensure only admins can access

    def index
      @total_users = User.count
      @total_orders = Order.count
      @total_transactions = Transaction.count
      @total_stocks = Stock.count
      @total_volume = UserStock.sum(:quantity)
      @latest_orders = Order.order(created_at: :desc).limit(5)
      @latest_transactions = Transaction.order(created_at: :desc).limit(5)
    end
  end
end
