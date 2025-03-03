class Transaction < ApplicationRecord
  belongs_to :order
  belongs_to :user

  enum transaction_type: { buy: "buy", sell: "sell" }

  validates :transaction_type, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :brokerage, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :taxes, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_amount, presence: true

  before_validation :calculate_brokerage_and_taxes

  private

  def calculate_brokerage_and_taxes
    brokerage_percentage = 0.02  # 2% Brokerage
    tax_percentage = 0.18  # 18% Tax

    self.brokerage = amount * brokerage_percentage
    self.taxes = amount * tax_percentage

    if buy? # Buying stock
      self.total_amount = amount + brokerage + taxes
    else # Selling stock
      self.total_amount = amount - brokerage - taxes
    end
  end
end
