FactoryBot.define do
    factory :user_stock do
      association :user
      association :stock, factory: :stock
  
      quantity { Faker::Number.between(from: 1, to: 100) }
      purchased_price { Faker::Number.decimal(l_digits: 3, r_digits: 2) }
      current_price { nil } # Let the model callback set it
  
      after(:build) do |user_stock|
        user_stock.current_price ||= user_stock.stock.current_price || 100.0
      end
    end
  end
  