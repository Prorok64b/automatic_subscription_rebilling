FactoryBot.define do
  factory :subscription do
    payment_on { Date.today + 1.month }
    price { BigDecimal('34.99') }

    trait :inactive do
      active { false }
    end

    trait :active do
      active { true }
    end

    user
  end
end
