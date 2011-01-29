class AddConstraintsToRepos < ActiveRecord::Migration
  def self.up
    change_column :repositories, :name, :string, null: false
    change_column :repositories, :user, :string, null: false
  end

  def self.down
    change_column :repositories, :name, :string, null: true
    change_column :repositories, :user, :string, null: true
  end
end
