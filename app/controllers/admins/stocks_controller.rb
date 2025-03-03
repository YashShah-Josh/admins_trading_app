class Admins::StocksController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_stock, only: %i[ show edit update destroy ]

  def index
    @stocks = Stock.all
  end

  def show; end

  def new
    @stock = Stock.new
  end

  def edit; end

  def create
    @stock = Stock.new(stock_params)
    if @stock.save
      redirect_to admins_stocks_path, notice: "Stock was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @stock.update(stock_params)
      redirect_to admins_stocks_path, notice: "Stock was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @stock.destroy!
    redirect_to admins_stocks_path, notice: "Stock was successfully deleted.", status: :see_other
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:symbol, :company_name, :current_price, :price_change, :quantity, :is_active)
  end
end
