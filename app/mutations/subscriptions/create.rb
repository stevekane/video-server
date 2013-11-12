module Subscriptions
  class Create < Mutations::Command

    required do
      model  :user
      string :stripe_token
      integer :plan_id
    end

    def execute
      stripe_customer = Stripe::Customer.create(
        card:        stripe_token,
        plan:        plan_id.to_s,
        email:       user.email,
        description: "#{user.full_name}: #{user.email}"
      )

      user.update_attribute(:stripe_customer_id, stripe_customer.id)

      stripe_subscription = stripe_customer.subscription
      stripe_card         = stripe_customer.cards.first
      subscription_attributes = {
        stripe_id:                   stripe_subscription.id,
        next_bill_date:              Time.at(stripe_subscription.current_period_end),
        next_bill_amount:            stripe_subscription.plan.amount,
        credit_card_last_four:       stripe_card.last4,
        credit_card_expiration_date: Date.new(stripe_card.exp_year, stripe_card.exp_month)
      }
      subscription = user.subscriptions.create(subscription_attributes)
      subscription.activate!

      return subscription
    end

  end
end
