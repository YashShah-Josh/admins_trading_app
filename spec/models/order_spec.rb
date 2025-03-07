require 'rails_helper'

RSpec.describe Order, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:stock) }
  end

  describe "validations" do
    subject { FactoryBot.build(:order) } # Ensures uniqueness and presence validation work

    it { should validate_presence_of(:user_id) }
    it { should validate_presence_of(:stock_id) }
    it { should validate_presence_of(:status) }
    it { should define_enum_for(:status).with_values(pending: 0, completed: 1, canceled: 2) }

    it { should validate_numericality_of(:price).is_greater_than(0) }
    it { should validate_numericality_of(:quantity).only_integer.is_greater_than(0) }
  end

  describe "callbacks" do
    it "sets price before validation if not provided" do
      stock = FactoryBot.create(:stock, current_price: 100)
      order = FactoryBot.build(:order, stock: stock, quantity: 2, price: nil)
      order.valid?
      expect(order.price).to eq(200) # 100 * 2
    end
  end
end
