FactoryBot.define do
  factory :user do
    name { "Test User" }
    email { "test@example.com" }
    phone { "9876543210" } # Valid 10-digit Indian phone number
    pan { "ABCDE1234F" }
    address { "Valid address, City, State, Pincode" }
    balance { 0 }
    password { "Password@123" }
    password_confirmation { "Password@123" }
  end
end
