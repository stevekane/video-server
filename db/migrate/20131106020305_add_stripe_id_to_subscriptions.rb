class AddStripeIdToSubscriptions < ActiveRecord::Migration
  def change
    remove_column :subscriptions, :stripe_token
    add_column :subscriptions, :stripe_id, :string
    add_column :subscriptions, :credit_card_last_four, :string
    add_column :subscriptions, :credit_card_expiration_date, :date
    add_column :subscriptions, :next_bill_date, :timestamp
    add_column :subscriptions, :next_bill_amount, :integer

    add_index :subscriptions, :stripe_id
  end
end
