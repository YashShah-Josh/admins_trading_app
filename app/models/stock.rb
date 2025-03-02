class Stock < ApplicationRecord
  validates :symbol, presence: true, uniqueness: true, length: { minimum: 1, maximum: 10 }
  validates :company_name, presence: true, length: { minimum: 2, maximum: 100 }
  validates :current_price, numericality: { greater_than_or_equal_to: 0 }
  validates :price_change, numericality: true
  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
