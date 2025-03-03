class CreatePrices < ActiveRecord::Migration[7.2]
  def change
    create_table :prices do |t|
      t.references :stock, null: false, foreign_key: true
      t.float :price
      t.datetime :recorded_at

      t.timestamps
    end
    add_index :prices, :recorded_at
  end
end
