FactoryBot.define do
  factory :payment_order do
    status { PaymentOrder::Statuses::CREATED }
    cash_amount { BigDecimal('49.99') }

    trait :created do
      status { PaymentOrder::Statuses::CREATED }
    end

    trait :pending do
      status { PaymentOrder::Statuses::PENDING }
    end

    trait :success do
      status { PaymentOrder::Statuses::SUCCESS }
    end

    trait :partial_success do
      status { PaymentOrder::Statuses::PARTIAL_SUCCESS }
    end

    trait :fail do
      status { PaymentOrder::Statuses::FAIL }
    end
  end
end
