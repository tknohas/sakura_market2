FactoryBot.define do
  factory :purchase_item do
    product { nil }
    purchase { nil }
    amount { 1 }
  end
end
