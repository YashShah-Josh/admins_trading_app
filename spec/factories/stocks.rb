FactoryBot.define do
    factory :stock do
      symbol { "TCS" }
      company_name { "Tata Consultancy Services" }
      current_price { 1000 }
      price_change { -10 }
      quantity { 500 }
    end
  end
  