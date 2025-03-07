require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe "associations" do
    it { should have_many(:prices).dependent(:destroy) }
    it { should have_many(:user_stocks) }
    it { should have_many(:users).through(:user_stocks) }
  end

  describe "validations" do
    subject { FactoryBot.build(:stock) }

    it { should validate_presence_of(:symbol) }
    it { should validate_length_of(:symbol).is_at_least(1).is_at_most(10) }
    it { should validate_uniqueness_of(:symbol) }

    it { should validate_presence_of(:company_name) }
    it { should validate_length_of(:company_name).is_at_least(2).is_at_most(100) }

    it { should validate_numericality_of(:price_change) }
    it { should validate_numericality_of(:quantity).only_integer.is_greater_than_or_equal_to(0) }

    it "requires current_price to be a number greater than or equal to 0" do
      stock = FactoryBot.build(:stock, current_price: -1)
      expect(stock).not_to be_valid
      expect(stock.errors[:current_price]).to include("must be a valid number")

      stock.current_price = 100
      expect(stock).to be_valid
    end
  end

  describe "callbacks" do

    it "keeps current_price unchanged if no price records exist" do
      stock = FactoryBot.create(:stock, current_price: 500)
      stock.valid?
      expect(stock.current_price).to eq(500)
    end
  end
end
