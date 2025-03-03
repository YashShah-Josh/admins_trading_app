class CreateUserStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :user_stocks do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.integer :quantity
      t.float :purchased_price
      t.float :current_price

      t.timestamps
    end
  end
end
