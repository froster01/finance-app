FactoryBot.define do
  factory :transaction do
    amount { "9.99" }
    description { "MyString" }
    date { "2026-03-22" }
    category { "MyString" }
    transaction_type { 1 }
    user { nil }
  end
end
