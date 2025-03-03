# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
# Create an Admin (prevents duplicate creation)
require 'csv'

CSV.foreach(Rails.root.join("/home/josh/Documents/admins_trading_app/alpha_vantage_reliance.csv"), headers: true) do |row|
  stock = Stock.find_by(symbol: row["stock_symbol"])
  next unless stock # Skip if stock is not found

  Price.find_or_create_by(
    stock_id: stock.id,
    recorded_at: DateTime.parse(row["date"]),
    price: row["price"].to_f
  )
end

puts "Data imported successfully!"
