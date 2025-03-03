module Admins
  class TransactionsController < ApplicationController
    before_action :authenticate_admin!
    before_action :set_transaction, only: [:show, :destroy]

    def index
      @transactions = Transaction.all.order(transaction_date: :desc)
    end

    def show; end

    def destroy
      @transaction.destroy
      redirect_to admins_transactions_path, notice: "Transaction deleted successfully."
    end

    private

    def set_transaction
      @transaction = Transaction.find(params[:id])
    end
  end
end
