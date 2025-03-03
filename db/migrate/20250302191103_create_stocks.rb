class CreateStocks < ActiveRecord::Migration[7.2]
  def change
    create_table :stocks do |t|
      t.string :symbol
      t.string :company_name
      t.float :current_price
      t.float :price_change
      t.integer :quantity
      t.boolean :is_active, default: true, null: false

      t.timestamps
    end
  end
end
