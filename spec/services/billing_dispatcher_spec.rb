require 'rails_helper'

describe BillingDispatcher do
  describe '.call' do
    subject { described_class.call(subscription: subscription) }

    let(:user) { build(:user, bank_cards: [bank_card]) }
    let(:bank_card) { build(:bank_card, :primary) }
    let!(:subscription) do
      create(
        :subscription,
        :inactive,
        user: user,
        price: 100,
        cash_amount_paid: cash_amount_paid
      )
    end

    before do
      allow(Bank::CardCharger).to receive(:call)
        .and_return(error_bank_response)
    end

    let(:success_bank_response) do
      Bank::CardCharger::Response.new(
        code: :success,
        msg: 'Transaction has been completed!'
      )
    end

    let(:insufficient_funds_bank_response) do
      Bank::CardCharger::Response.new(
        code: :insufficient_funds,
        msg: 'Insufficient funds on the bank account'
      )
    end

    let(:error_bank_response) do
      Bank::CardCharger::Response.new(
        code: :error,
        msg: 'Invalid card number'
      )
    end

    shared_examples_for 'payment orders creation' do |count|
      it 'creates a payment_order' do
        expect { subject }.to change { PaymentOrder.count }.by(count)
      end
    end

    shared_examples_for 'setting payment_order status to partial_success' do
      it 'updates payment_order status' do
        subject

        expect(PaymentOrder.last.status).to eq(PaymentOrder::Statuses::PARTIAL_SUCCESS)
      end
    end

    shared_examples_for 'subscription activation' do
      it 'activates subscription' do
        expect { subject }
          .to change { subscription.active }.from(false).to(true)
          .and change { subscription.payment_on }
      end
    end

    shared_examples_for 'keeping subscription inactive' do
      it 'does not activate subscription' do
        expect { subject }.not_to change { subscription.active }
      end
    end

    shared_examples_for 'scheduling worker to charge difference in a week' do
      it 'schedules new worker to charge a difference in a week' do
        subject

        expect(SubscriptionPaymentWorker.jobs.size).to eq(1)

        worker_args = SubscriptionPaymentWorker.jobs.last['args']
        enqueued_at = Time.at(SubscriptionPaymentWorker.jobs.last['at']).to_date

        expect(enqueued_at).to eq(Date.today + 1.week)
        expect(worker_args).to eq([subscription.id])
      end
    end

    shared_examples_for 'scheduling subscription renewal' do
      it 'schedules new worker to renew subscription' do
        subject

        expect(SubscriptionPaymentWorker.jobs.size).to eq(1)

        worker_args = SubscriptionPaymentWorker.jobs.last['args']
        enqueued_at = Time.at(SubscriptionPaymentWorker.jobs.last['at']).to_date

        expect(enqueued_at).to eq(subscription.payment_on)
        expect(worker_args).to eq([subscription.id])
      end
    end

    shared_examples_for 'scheduling no workers' do
      it 'schedules no workers' do
        subject

        expect(SubscriptionPaymentWorker.jobs.size).to eq(0)
      end
    end

    context 'when given unpaid subscription' do
      let(:cash_amount_paid) { 0 }

      context 'when there is enough funds to pay 100%' do
        before do
          allow(Bank::CardCharger).to receive(:call)
            .with(bank_card, 100)
            .and_return(success_bank_response)
        end

        context 'when payment is successful' do
          it { is_expected.to eq(:success) }

          include_examples 'payment orders creation', 1
          include_examples 'subscription activation'
          include_examples 'scheduling subscription renewal'
        end
      end

      context 'when there is enough funds to pay 75%' do
        before do
          allow(Bank::CardCharger).to receive(:call)
            .and_return(insufficient_funds_bank_response)

          allow(Bank::CardCharger).to receive(:call)
            .with(bank_card, 75)
            .and_return(success_bank_response)
        end

        context 'when payment is successful' do
          it { is_expected.to eq(:insufficient_funds) }

          include_examples 'payment orders creation', 2
          include_examples 'scheduling worker to charge difference in a week'
        end
      end

      context 'when there is enough funds to pay 50%' do
        before do
          allow(Bank::CardCharger).to receive(:call)
            .and_return(insufficient_funds_bank_response)

          allow(Bank::CardCharger).to receive(:call)
            .with(bank_card, 50)
            .and_return(success_bank_response)
        end

        context 'when payment is successful' do
          it { is_expected.to eq(:insufficient_funds) }

          include_examples 'payment orders creation', 3
          include_examples 'scheduling worker to charge difference in a week'
        end
      end

      context 'when there is enough funds to pay 25%' do
        before do
          allow(Bank::CardCharger).to receive(:call)
            .and_return(insufficient_funds_bank_response)

          allow(Bank::CardCharger).to receive(:call)
            .with(bank_card, 25)
            .and_return(success_bank_response)
        end

        context 'when payment is successful' do
          it { is_expected.to eq(:insufficient_funds) }

          include_examples 'payment orders creation', 4
          include_examples 'scheduling worker to charge difference in a week'
        end
      end

      context 'when there is no funds to pay even 25%' do
        before do
          allow(Bank::CardCharger).to receive(:call)
            .and_return(insufficient_funds_bank_response)
        end

        context 'when payment is successful' do
          it { is_expected.to eq(:insufficient_funds) }

          include_examples 'payment orders creation', 4
          include_examples 'scheduling no workers'
        end
      end
    end

    context 'when given unpaid subscription' do
      let(:cash_amount_paid) { 25 }

      context 'when bank responses with success' do
        before do
          allow(Bank::CardCharger).to receive(:call)
            .with(bank_card, 75)
            .and_return(success_bank_response)
        end

        include_examples 'payment orders creation', 1
        include_examples 'subscription activation'
        include_examples 'scheduling subscription renewal'
      end

      context 'when bank responses with insufficient funds' do
        before do
          allow(Bank::CardCharger).to receive(:call)
            .with(bank_card, 75)
            .and_return(insufficient_funds_bank_response)
        end

        include_examples 'payment orders creation', 1
        include_examples 'keeping subscription inactive'
      end

      context 'when bank responses with error' do
        before do
          allow(Bank::CardCharger).to receive(:call)
            .with(bank_card, 75)
            .and_return(error_bank_response)
        end

        include_examples 'payment orders creation', 1
        include_examples 'keeping subscription inactive'
      end
    end
  end
end
