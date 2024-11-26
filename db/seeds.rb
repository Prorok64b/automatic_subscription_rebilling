Subscription.destroy_all
BankCard.destroy_all
User.destroy_all
PaymentOrder.destroy_all

user = FactoryBot.create(:user, bank_cards: [FactoryBot.build(:bank_card, :primary)])

# inactive, unpaid
subscription = FactoryBot.create(
  :subscription,
  :inactive,
  user: user,
  price: 100,
  payment_on: nil,
  cash_amount_paid: 0
)

puts "subscription (inactive, unpaid) id: #{subscription.id}"

# active, paid
subscription = FactoryBot.create(
  :subscription,
  :active,
  user: user,
  price: 100,
  payment_on: Date.today + 1.month,
  cash_amount_paid: 100
)

puts "subscription (active, paid) id: #{subscription.id}"

# expired
subscription = FactoryBot.create(
  :subscription,
  :active,
  user: user,
  price: 100,
  payment_on: Date.today - 1.day,
  cash_amount_paid: 100
)

puts "subscription (expired) id: #{subscription.id}"
