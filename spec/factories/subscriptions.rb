FactoryBot.define do
  factory :subscription do
    percentage_paid { 100 }
    next_payment_on { Date.today + 1.month }

    user
  end
end
