class Admins::PricesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_price, only: [ :show, :destroy ]

  def index
    @prices = Price.includes(:stock).order(recorded_at: :desc)
  end

  def show
    @stock_prices = Price.where(stock_id: params[:id]).order(recorded_at: :desc)
  end

  def create
    @price = Price.new(price_params)

    if @price.save
      redirect_to admins_prices_path, notice: "Price record added successfully."
    else
      render :index, status: :unprocessable_entity
    end
  end

  def destroy
    @price.destroy
    redirect_to admins_prices_path, notice: "Price record deleted successfully."
  end

  private

  def set_price
    @price = Price.find(params[:id])
  end

  def price_params
    params.require(:price).permit(:stock_id, :price, :recorded_at)
  end
end
