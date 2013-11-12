class Subscription < ActiveRecord::Base
  include ActiveModel::Transitions

  belongs_to :user
  has_many   :stripe_events

  def next_bill_amount
    read_attribute(:next_bill_amount) / 100.to_f
  end

  state_machine initial: :inactive, auto_scopes: true do
    state :inactive
    state :active
    state :cancelled
    state :past_due
    event :activate do
      transitions to: :active, from: [:inactive, :past_due]
    end
    event :cancel do
      transitions to: :cancelled, from: [:active, :past_due]
    end
    event :suspend do
      transitions to: :past_due, from: [:active]
    end
  end

end
