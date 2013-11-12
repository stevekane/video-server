class AddUidProviderAndGithubTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :github_token, :string
    add_column :users, :github_uid, :integer
    add_column :users, :github_nickname, :string
    add_column :users, :github_image, :string
  end
end
