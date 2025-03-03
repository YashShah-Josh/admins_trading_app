class Order < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  enum status: { pending: "pending", completed: "completed", canceled: "canceled" }

  validates :user_id, presence: true
  validates :stock_id, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true

  before_validation :set_price

  private

  def set_price
    self.price ||= stock.current_price * quantity
  end
end
