require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { build(:user) }

  describe '#primary_bank_card' do
    subject { user.primary_bank_card }

    before do
      create(:bank_card, :primary, id: 1, user: user)
      create(:bank_card, id: 2, user: user)
      create(:bank_card, id: 3, user: user)
    end

    it 'returns primary bank card' do
      expect(subject.id).to eq(1)
    end
  end
end
