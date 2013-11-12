class AddBiographicalColumnsToUser < ActiveRecord::Migration
  def change
    add_column :users, :twitter, :string
    add_column :users, :blog, :string
    add_column :users, :about, :text
    add_column :users, :phone, :string
    add_column :users, :birthday, :string
    add_column :users, :current_status, :string
    add_column :users, :skills, :text
  end
end
