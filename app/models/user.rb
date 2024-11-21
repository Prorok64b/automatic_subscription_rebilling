class User < ApplicationRecord
  has_many :bank_cards

  def primary_bank_card
    bank_cards.primary.first
  end
end
