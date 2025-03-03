json.extract! stock, :id, :symbol, :company_name, :current_price, :price_change, :quantity, :is_active, :created_at, :updated_at
json.url stock_url(stock, format: :json)
