FactoryBot.define do
  factory :admin do
    name { "Admin User" }
    email { "admin@example.com" }
    password { "Secure@123" }
    password_confirmation { "Secure@123" }
    confirmed_at { Time.now } # Required for confirmable Devise module
  end
end
