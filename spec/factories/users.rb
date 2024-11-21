FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }

    after :create do |user|
      create(:bank_card, :primary, user: user)
    end
  end
end
