class AddSubscriptionIdToStripeEvents < ActiveRecord::Migration
  def change
    add_column :stripe_events, :subscription_id, :integer
    add_index :stripe_events, :subscription_id
  end
end
