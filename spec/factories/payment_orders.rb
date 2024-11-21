FactoryBot.define do
  factory :payment_order do
    status { 'pending' }
    cash_amount { BigDecimal('49.99') }
    percentage_paid { 50 }

    trait :success do
      status { 'success' }
    end

    trait :fail do
      status { 'fail' }
    end
  end
end
