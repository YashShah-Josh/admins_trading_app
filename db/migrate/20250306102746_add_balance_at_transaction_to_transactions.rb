class AddBalanceAtTransactionToTransactions < ActiveRecord::Migration[7.2]
  def change
    add_column :transactions, :balance_at_transaction, :float
  end
end
