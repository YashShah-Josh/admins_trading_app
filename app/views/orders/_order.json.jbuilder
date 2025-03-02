json.extract! order, :id, :user_id, :stock_id, :order_type, :price, :quantity, :status, :created_at, :updated_at
json.url order_url(order, format: :json)
