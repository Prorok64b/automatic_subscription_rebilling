FactoryBot.define do
  factory :bank_card do
    number { '1111000011110000' }
    expiry_month { '12' }
    expiry_year { Date.today.year.to_s }
    cvv { '123' }
    primary { false }

    trait :primary do
      primary { true }
    end
  end
end
