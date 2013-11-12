class AddAdditionalColumnsToStripeEvents < ActiveRecord::Migration
  def change
    add_column :stripe_events, :object, :string
    add_column :stripe_events, :pending_webhooks, :integer
    add_column :stripe_events, :request, :string
    add_column :stripe_events, :stripe_webhook, :text
  end
end
