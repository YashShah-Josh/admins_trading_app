class UserStock < ApplicationRecord
    belongs_to :user
    belongs_to :stock
  
    validates :quantity, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    validates :purchased_price, :current_price, numericality: { greater_than_or_equal_to: 0 }
  
    def update_current_price(new_price)
      self.current_price = new_price
      save!
    end
  end
  