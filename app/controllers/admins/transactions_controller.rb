class Admins::TransactionsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_transaction, only: [ :show, :destroy ]

  def index
    @transactions = Transaction.all.order(created_at: :desc)
  end

  def show; end

  def destroy
    @transaction.destroy
    redirect_to admins_transactions_path, notice: "Transaction successfully deleted."
  end

  private

  def set_transaction
    @transaction = Transaction.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:order_id, :user_id, :transaction_type, :amount)
  end
end
