class ChangeUsersTableToFitOauth < ActiveRecord::Migration
  def self.up
    remove_column :users, :crypted_password
    remove_column :users, :password_salt
    change_column :users, :github_key, :string, null: false
    rename_column :users, :github_key, :github_access_token
  end

  def self.down
    add_column :users, :crypted_password, string, null: false
    add_column :users, :password_salt, string, null: false
    change_column :users, :github_key, :string, null: true
    rename_column :users, :github_access_token, :github_key
  end
end
