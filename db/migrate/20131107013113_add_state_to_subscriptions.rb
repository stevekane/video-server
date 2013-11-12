class AddStateToSubscriptions < ActiveRecord::Migration
  def change
    add_column :subscriptions, :state, :string, default: "inactive"
    add_index :subscriptions, :state
  end
end
