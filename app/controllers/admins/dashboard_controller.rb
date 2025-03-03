class Admins::DashboardController < ApplicationController
  before_action :authenticate_admin!

  def index
    @stocks = Stock.all
    @orders = Order.all
  end
end
