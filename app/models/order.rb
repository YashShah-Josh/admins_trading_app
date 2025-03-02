class Order < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  enum order_type: { buy: "buy", sell: "sell" }
  enum status: { pending: "pending", completed: "completed", canceled: "canceled" }

  validates :user_id, presence: true
  validates :stock_id, presence: true
  validates :order_type, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true
end
