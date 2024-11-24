class SubscriptionPaymentWorker
  include Sidekiq::Job

  def perform(subscription_id, percentage_paid)
    subscription = Subscription.find(subscription_id)

    BillingDispatcher.call(
      subscription: subscription,
      percentage_paid: percentage_paid
    )
  end
end
