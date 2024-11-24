require 'rails_helper'

describe BankCard, type: :model do
  describe 'Scopes' do
    describe '.primary' do
      subject { described_class.primary.pluck(:id) }

      let!(:user) { create(:user) }
      let!(:primary_card) { create(:bank_card, :primary, user: user) }

      before do
        create(:bank_card, user: user)
        create(:bank_card, user: user)
      end

      it { is_expected.to eq([primary_card.id]) }
    end
  end
end
