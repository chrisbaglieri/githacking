class AddGithubKeyToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :github_key, :string
  end

  def self.down
    remove_column :users, :github_key
  end
end
