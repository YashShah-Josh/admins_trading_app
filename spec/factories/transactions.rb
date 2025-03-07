FactoryBot.define do
  factory :transaction do
    association :user
    association :order
    transaction_type { "buy" }
    amount { 1000.0 }
    brokerage { 0.0 }
    taxes { 0.0 }
    total_amount { 1000.0 }
    balance_at_transaction { 5000.0 } # Some valid balance
  end
end
