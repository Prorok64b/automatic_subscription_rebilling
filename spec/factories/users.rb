FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }

    trait :with_card do
      bank_cards { [build(:bank_card, :primary)] }
    end
  end
end
