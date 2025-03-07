class UserStock < ApplicationRecord
  belongs_to :user
  belongs_to :stock

  validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :purchased_price, :current_price, numericality: { greater_than_or_equal_to: 0 }

  before_validation :set_current_price, if: -> { current_price.nil? && stock.present? }

  private

  def set_current_price
    self.current_price = stock.current_price
  end
end
