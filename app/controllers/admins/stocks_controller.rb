module Admins
  class StocksController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_stock, only: [:edit, :update, :destroy]

    def index
      @stocks = Stock.all.order(:symbol)
    end

    def new
      @stock = Stock.new
    end

    def create
      @stock = Stock.new(stock_params)
      if @stock.save
        redirect_to admins_stocks_path, notice: "Stock successfully created."
      else
        render :new
      end
    end

    def edit; end

    def update
      if @stock.update(stock_params)
        redirect_to admins_stocks_path, notice: "Stock updated successfully."
      else
        render :edit
      end
    end

    def destroy
      @stock.destroy
      redirect_to admins_stocks_path, notice: "Stock deleted successfully."
    end

    private

    def set_stock
      @stock = Stock.find(params[:id])
    end

    def stock_params
      params.require(:stock).permit(:symbol, :company_name, :current_price, :price_change, :quantity, :is_active)
    end
  end
end
