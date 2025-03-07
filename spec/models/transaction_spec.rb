require 'rails_helper'

RSpec.describe Transaction, type: :model do
  let(:user) { create(:user, balance: 5000.0) }
  let(:stock) { create(:stock) }
  let(:order) { create(:order, user: user, stock: stock, price: 1000, quantity: 1) }

  subject { build(:transaction, user: user, order: order, amount: 1000.0, transaction_type: "buy") }

  describe "associations" do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:order) }
  end

  describe "validations" do
    it { is_expected.to validate_presence_of(:transaction_type) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }

    it { is_expected.to validate_numericality_of(:brokerage).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:taxes).is_greater_than_or_equal_to(0) }
    it { is_expected.to validate_numericality_of(:total_amount) }
    it { is_expected.to validate_numericality_of(:balance_at_transaction) }
  end

  describe "callbacks" do
    context "before_validation callbacks" do
      it "sets balance_at_transaction to user's current balance" do
        transaction = build(:transaction, user: user, order: order, amount: 1000.0)
        transaction.valid? # Triggers before_validation

        expect(transaction.balance_at_transaction).to eq(user.balance)
      end

      it "calculates brokerage and taxes correctly for buying" do
        transaction = build(:transaction, user: user, order: order, amount: 1000.0, transaction_type: "buy")
        transaction.valid? # Triggers before_validation

        expected_brokerage = 1000.0 * 0.02 # 2% of amount
        expected_taxes = expected_brokerage * 0.18 # 18% of brokerage
        expected_total_amount = 1000.0 + expected_brokerage + expected_taxes

        expect(transaction.brokerage).to eq(expected_brokerage)
        expect(transaction.taxes).to eq(expected_taxes)
        expect(transaction.total_amount).to eq(expected_total_amount)
      end

      it "calculates brokerage and taxes correctly for selling" do
        transaction = build(:transaction, user: user, order: order, amount: 1000.0, transaction_type: "sell")
        transaction.valid? # Triggers before_validation

        expected_brokerage = 1000.0 * 0.02 # 2% of amount
        expected_taxes = expected_brokerage * 0.18 # 18% of brokerage
        expected_total_amount = 1000.0 - expected_brokerage - expected_taxes

        expect(transaction.brokerage).to eq(expected_brokerage)
        expect(transaction.taxes).to eq(expected_taxes)
        expect(transaction.total_amount).to eq(expected_total_amount)
      end
    end
  end
end
