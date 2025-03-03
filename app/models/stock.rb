class Stock < ApplicationRecord
  has_many :prices, dependent: :destroy
  has_many :user_stocks
  has_many :users, through: :user_stocks

  validates :symbol, presence: true, uniqueness: true, length: { minimum: 1, maximum: 10 }
  validates :company_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :current_price, numericality: { greater_than_or_equal_to: 0 }
  validates :price_change, numericality: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  before_validation :set_current_price

  def set_current_price
    latest_price = prices.order(recorded_at: :desc).first
    self.current_price = latest_price ? latest_price.price : self.current_price
  end
end
