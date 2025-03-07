require 'rails_helper'

RSpec.describe UserStock, type: :model do
  let(:user) { create(:user) }
  let(:stock) { create(:stock, current_price: 100) }

  it { should belong_to(:user) }
  it { should belong_to(:stock).required }

  it { should validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:purchased_price).is_greater_than_or_equal_to(0) }
  it { should validate_numericality_of(:current_price).is_greater_than_or_equal_to(0) }

  context "callbacks" do
    it "does not override current_price if already set" do
      user_stock = create(:user_stock, user: user, stock: stock, current_price: 120)
      expect(user_stock.current_price).to eq(120) # Ensures callback doesn't overwrite manual value
    end

    it "sets current_price if nil" do
      user_stock = create(:user_stock, user: user, stock: stock, current_price: nil)
      expect(user_stock.current_price).to eq(100) # Should get stock's current price
    end
  end
end
