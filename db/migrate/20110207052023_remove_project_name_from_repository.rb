class RemoveProjectNameFromRepository < ActiveRecord::Migration
  def self.up
    remove_column :repositories, :project_name
  end

  def self.down
    add_column :repositories, :project_name, :string, :null => false
  end
end
