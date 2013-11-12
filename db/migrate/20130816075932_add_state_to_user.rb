class AddStateToUser < ActiveRecord::Migration
  def change
    add_column :users, :state, :string
    add_column :users, :checked_in_at, :datetime
  end
end
