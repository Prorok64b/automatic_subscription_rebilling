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

  describe 'only one primary card per user allowed' do
    subject { new_instance.save }

    let!(:user) { create(:user) }
    let(:new_instance) { build(:bank_card, :primary, user: user) }

    it { is_expected.to eq(true) }

    context 'when user has a primary card' do
      before do
        create(:bank_card, :primary, user: user)
      end

      it { is_expected.to eq(false) }

      it 'returns proper error' do
        subject

        errors = new_instance.errors.messages

        expect(errors).to eq({ base: ['Only one primary card per user allowed'] })
      end
    end
  end
end
