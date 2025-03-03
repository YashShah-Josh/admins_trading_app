module Admins
  class OrdersController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_order, only: [:edit, :update, :destroy]

    def index
      @orders = Order.all.order(created_at: :desc)
    end

    def edit; end

    def update
      if @order.update(order_params)
        redirect_to admins_orders_path, notice: "Order updated successfully."
      else
        render :edit
      end
    end

    def destroy
      @order.destroy
      redirect_to admins_orders_path, notice: "Order deleted successfully."
    end

    private

    def set_order
      @order = Order.find(params[:id])
    end

    def order_params
      params.require(:order).permit(:status)
    end
  end
end
