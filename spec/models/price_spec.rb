require 'rails_helper'

RSpec.describe Price, type: :model do
  describe "associations" do
    it { should belong_to(:stock) }
  end

  describe "validations" do
    subject { FactoryBot.build(:price) } # Ensures uniqueness and other validations work

    it { should validate_presence_of(:price) }
    it { should validate_numericality_of(:price).is_greater_than(0) }

    it { should validate_presence_of(:recorded_at) }

    it "is invalid with a negative price" do
      price = FactoryBot.build(:price, price: -10)
      expect(price).not_to be_valid
      expect(price.errors[:price]).to include("must be greater than 0")
    end

    it "is valid with a positive price" do
      price = FactoryBot.build(:price, price: 150)
      expect(price).to be_valid
    end

    it "is invalid without a recorded_at timestamp" do
      price = FactoryBot.build(:price, recorded_at: nil)
      expect(price).not_to be_valid
      expect(price.errors[:recorded_at]).to include("can't be blank")
    end
  end
end
