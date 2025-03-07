FactoryBot.define do
    factory :order do
      association :user
      association :stock
      quantity { 10 }
      price { 1000 }
      status { "pending" }
    end
  end
  