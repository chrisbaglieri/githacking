class RemoveProjectNameFromRepositories < ActiveRecord::Migration
  def self.up
    remove_column :repositories, :project_name
    change_column :repositories, :name, :string, null: false
    change_column :repositories, :owner, :string, null: false
  end

  def self.down
    add_column :repositories, :project_name, :string
    change_column :repositories, :name, :string, null: true
    change_column :repositories, :owner, :string, null: true
  end
end
