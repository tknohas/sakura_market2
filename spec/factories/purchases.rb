FactoryBot.define do
  factory :purchase do
    user { nil }
    subtotal { 0 }
    shipping_fee { 0 }
    delivery_fee { 0 }
    tax { 0 }
    total_price { 0 }
  end
end
