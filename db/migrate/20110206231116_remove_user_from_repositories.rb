class RemoveUserFromRepositories < ActiveRecord::Migration
  def self.up
    remove_column :repositories, :user
    change_column :repositories, :owner, :string, null: false
  end

  def self.down
    add_column :repositories, :user, :string, null: false
    change_column :repositories, :owner, :string, null: true
  end
end
