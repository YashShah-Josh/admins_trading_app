class Transaction < ApplicationRecord
  belongs_to :order
  belongs_to :user

  validates :transaction_type, presence: true, inclusion: { in: ["credit", "debit"] }
  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :brokerage, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :taxes, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_amount, presence: true, numericality: { greater_than_or_equal_to: 0 }

  before_save :calculate_brokerage_and_taxes

  private

  def calculate_brokerage_and_taxes
    brokerage_percentage = 0.02  # 2% Brokerage
    tax_percentage = 0.18  # 18% Tax

    self.brokerage = amount * brokerage_percentage
    self.taxes = amount * tax_percentage

    if transaction_type == "debit"  # Buying stock
      self.total_amount = amount + brokerage + taxes
    else  # "credit" (selling stock)
      self.total_amount = amount - brokerage - taxes
    end
  end
end
