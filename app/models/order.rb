class Order < ApplicationRecord
  belongs_to :user, required: true
  belongs_to :stock, required: true

  enum status: { pending: "pending", completed: "completed", canceled: "canceled" }

  validates :user_id, presence: true
  validates :stock_id, presence: true
  validates :price, numericality: { greater_than: 0 }
  validates :quantity, numericality: { only_integer: true, greater_than: 0 }
  validates :status, presence: true

  before_validation :set_price

  private

  def set_price
    return unless stock # Ensure stock is present
    self.price ||= stock.current_price * quantity
  end
end
