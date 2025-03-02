class CreateOrders < ActiveRecord::Migration[7.2]
  def change
    create_table :orders do |t|
      t.references :user, null: false, foreign_key: true
      t.references :stock, null: false, foreign_key: true
      t.string :order_type
      t.decimal :price
      t.integer :quantity
      t.string :status

      t.timestamps
    end
  end
end
