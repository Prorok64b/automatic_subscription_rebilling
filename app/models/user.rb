class User < ApplicationRecord
  has_many :bank_cards
  has_many :subscriptions

  def primary_bank_card
    bank_cards.primary.first
  end
end
