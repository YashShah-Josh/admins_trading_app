class CreateTransactions < ActiveRecord::Migration[7.2]
  def change
    create_table :transactions do |t|
      t.references :order, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.string :transaction_type
      t.float :amount
      t.float :brokerage
      t.float :taxes

      t.datetime :transaction_date

      t.timestamps
    end
  end
end
