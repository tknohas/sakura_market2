FactoryBot.define do
  factory :cart_item do
    product { nil }
    cart { nil }
    amount { 1 }
  end
end
