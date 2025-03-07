FactoryBot.define do
    factory :price do
      stock
      price { 100.0 }
      recorded_at { Time.current }
    end
  end
  