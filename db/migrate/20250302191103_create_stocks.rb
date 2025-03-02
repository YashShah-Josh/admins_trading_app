class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :company_name
      t.decimal :current_price
      t.decimal :price_change
      t.integer :quantity
      t.boolean :is_active

      t.timestamps
    end
  end
end
