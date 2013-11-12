class CreateStripeEvents < ActiveRecord::Migration
  def change
    create_table :stripe_events do |t|
      t.string :event_id
      t.timestamp :created
      t.boolean :livemode
      t.string :event_type
      t.text :data
      t.boolean :processed, default: false
      t.timestamps
    end

    add_index :stripe_events, :event_id
  end
end
