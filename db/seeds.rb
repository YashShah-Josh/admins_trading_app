# # This file should ensure the existence of records required to run the application in every environment (production,
# # development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# # The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
# #
# # Example:
# #
# #   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
# #     MovieGenre.find_or_create_by!(name: genre_name)
# #   end
# # Create an Admin (prevents duplicate creation)
# admin = Admin.find_or_create_by!(email: "admin@tradingapp.com") do |a|
#   a.password = "Admin@123"
#   a.password_confirmation = "Admin@123"
#   a.role = "admin"
#   a.name = "Super Admin"
#   a.confirmed_at = Time.now
# end
# puts "Admin Created: #{admin.email}"

# # Create Stocks (Indian stock market companies)
# stocks_data = [
#   { symbol: "RELIANCE", company_name: "Reliance Industries", current_price: 2500.50, price_change: 12.30 },
#   { symbol: "TCS", company_name: "Tata Consultancy Services", current_price: 3600.75, price_change: -5.20 },
#   { symbol: "INFY", company_name: "Infosys", current_price: 1550.25, price_change: 8.40 },
#   { symbol: "HDFC", company_name: "HDFC Bank", current_price: 1450.80, price_change: -3.10 },
#   { symbol: "WIPRO", company_name: "Wipro", current_price: 750.60, price_change: 4.70 },
#   { symbol: "ICICIBANK", company_name: "ICICI Bank", current_price: 920.30, price_change: 2.60 },
#   { symbol: "HDFCLIFE", company_name: "HDFC Life Insurance", current_price: 590.10, price_change: -1.20 }
# ]

# stocks_data.each do |stock_data|
#   Stock.find_or_create_by!(symbol: stock_data[:symbol]) do |stock|
#     stock.company_name = stock_data[:company_name]
#     stock.current_price = stock_data[:current_price]
#     stock.price_change = stock_data[:price_change]
#     stock.quantity = rand(1000..5000)
#     stock.is_active = true
#   end
# end
# puts "Stocks Created!"

# # Create Users (dummy traders)
# 5.times do |i|
#   User.find_or_create_by!(email: "user#{i + 1}@tradingapp.com") do |user|
#     user.name = "User#{i + 1}"
#     user.password = "Password@123"
#     user.password_confirmation = "Password@123"
#     user.confirmed_at = Time.now
#     user.phone = "98765432#{i}"
#     user.pan = "ABCDE123#{i}"
#     user.address = "Mumbai, India"
#     user.balance = rand(50000..200000)
#   end
# end
# puts "Users Created!"

# # Create Orders (random buy/sell orders)
# 10.times do
#   Order.find_or_create_by!(
#     user: User.order("RANDOM()").first,
#     stock: Stock.order("RANDOM()").first,
#     order_type: [ "buy", "sell" ].sample,
#     price: rand(500..4000).round(2),
#     quantity: rand(1..100),
#     status: [ "pending", "completed", "cancelled" ].sample,
#   )
# end
# puts "Orders Created!"
# Clear existing data (optional, for development)


puts "Seeding stocks..."
Stock.find_or_create_by!([
  { symbol: "RELIANCE", company_name: "Reliance Industries", current_price: 2500.0, price_change: 0.0, quantity: 1000 },
  { symbol: "TCS", company_name: "Tata Consultancy Services", current_price: 3500.0, price_change: 0.0, quantity: 800 },
  { symbol: "INFY", company_name: "Infosys", current_price: 1700.0, price_change: 0.0, quantity: 1200 }
])

# puts "Seeding users..."
# user = User.find_or_create_by!(
#   name: "John Doe",
#   email: "john@example.com",
#   phone: "9876543210",
#   balance: 100000.0,
#   address: "123 Market St, Mumbai",
#   pan: "ABCDE1234F",
#   confirmed_at: Time.now
# )
# user.update!(password: "password")

# puts "Seeding admins..."
# admin = Admin.find_or_create_by!(
#   name: "Super Admin",
#   email: "admin@example.com",
#   role: "admin",
#   confirmed_at: Time.now
# )
# admin.update!(password: "adminpassword")

# puts "Seeding users..."
users_data = [
  { name: "Alice Sharma", email: "alice@example.com", phone: "9876543211", balance: 150000.0, address: "456 Stock St, Delhi", pan: "BCDEF2345G", confirmed_at: Time.now },
  { name: "Bob Kumar", email: "bob@example.com", phone: "9876543212", balance: 200000.0, address: "789 Trade Ave, Bangalore", pan: "CDEFG3456H", confirmed_at: Time.now },
  { name: "Charlie Singh", email: "charlie@example.com", phone: "9876543213", balance: 180000.0, address: "101 Equity Rd, Hyderabad", pan: "DEFGH4567I", confirmed_at: Time.now }
]

users = users_data.map do |user_data|
  User.find_or_create_by!(email: user_data[:email]) do |user|
    user.name = user_data[:name]
    user.phone = user_data[:phone]
    user.balance = user_data[:balance]
    user.address = user_data[:address]
    user.pan = user_data[:pan]
    user.confirmed_at = user_data[:confirmed_at]
    user.password = "password"
    user.password_confirmation = "password"
  end
end

puts "Seeding orders..."
orders = [
  Order.find_or_create_by!(user: users[0], stock: Stock.find_by(symbol: "RELIANCE"), price: 2500.0, quantity: 10, status: "completed"),
  Order.find_or_create_by!(user: users[1], stock: Stock.find_by(symbol: "TCS"), price: 3500.0, quantity: 5, status: "completed"),
  Order.find_or_create_by!(user: users[2], stock: Stock.find_by(symbol: "INFY"), price: 1700.0, quantity: 20, status: "completed")
]

puts "Seeding transactions..."
transactions = [
  Transaction.find_or_create_by!(order: orders[0], user: users[0], transaction_type: "buy", amount: 25000.0, brokerage: 50.0, taxes: 20.0, transaction_date: Time.now),
  Transaction.find_or_create_by!(order: orders[1], user: users[1], transaction_type: "buy", amount: 17500.0, brokerage: 35.0, taxes: 15.0, transaction_date: Time.now),
  Transaction.find_or_create_by!(order: orders[2], user: users[2], transaction_type: "buy", amount: 34000.0, brokerage: 68.0, taxes: 25.0, transaction_date: Time.now)
]

puts "Seeding user stocks..."
UserStock.find_or_create_by!([
  { user: users[0], stock: Stock.find_by(symbol: "RELIANCE"), quantity: 10, purchased_price: 2500.0, current_price: 2500.0 },
  { user: users[1], stock: Stock.find_by(symbol: "TCS"), quantity: 5, purchased_price: 3500.0, current_price: 3500.0 },
  { user: users[2], stock: Stock.find_by(symbol: "INFY"), quantity: 20, purchased_price: 1700.0, current_price: 1700.0 }
])


puts "Seeding completed!"

