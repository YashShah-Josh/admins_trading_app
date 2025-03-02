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
admin = Admin.find_or_create_by!(email: "admin@tradingapp.com") do |a|
  a.password = "Admin@123"
  a.password_confirmation = "Admin@123"
  a.role = "admin"
  a.name = "Super Admin"
  a.confirmed_at = Time.now
end
puts "Admin Created: #{admin.email}"

# Create Stocks (Indian stock market companies)
stocks_data = [
  { symbol: "RELIANCE", company_name: "Reliance Industries", current_price: 2500.50, price_change: 12.30 },
  { symbol: "TCS", company_name: "Tata Consultancy Services", current_price: 3600.75, price_change: -5.20 },
  { symbol: "INFY", company_name: "Infosys", current_price: 1550.25, price_change: 8.40 },
  { symbol: "HDFC", company_name: "HDFC Bank", current_price: 1450.80, price_change: -3.10 },
  { symbol: "WIPRO", company_name: "Wipro", current_price: 750.60, price_change: 4.70 },
  { symbol: "ICICIBANK", company_name: "ICICI Bank", current_price: 920.30, price_change: 2.60 },
  { symbol: "HDFCLIFE", company_name: "HDFC Life Insurance", current_price: 590.10, price_change: -1.20 }
]

stocks_data.each do |stock_data|
  Stock.find_or_create_by!(symbol: stock_data[:symbol]) do |stock|
    stock.company_name = stock_data[:company_name]
    stock.current_price = stock_data[:current_price]
    stock.price_change = stock_data[:price_change]
    stock.quantity = rand(1000..5000)
    stock.is_active = true
  end
end
puts "Stocks Created!"

# Create Users (dummy traders)
5.times do |i|
  User.find_or_create_by!(email: "user#{i + 1}@tradingapp.com") do |user|
    user.name = "User#{i + 1}"
    user.password = "Password@123"
    user.password_confirmation = "Password@123"
    user.confirmed_at = Time.now
    user.phone = "98765432#{i}"
    user.pan = "ABCDE123#{i}"
    user.address = "Mumbai, India"
    user.balance = rand(50000..200000)
  end
end
puts "Users Created!"

# Create Orders (random buy/sell orders)
10.times do
  Order.create!(
    user: User.order("RANDOM()").first,
    stock: Stock.order("RANDOM()").first,
    order_type: [ "buy", "sell" ].sample,
    price: rand(500..4000).round(2),
    quantity: rand(1..100),
    status: [ "pending", "completed", "cancelled" ].sample,
  )
end
puts "Orders Created!"
