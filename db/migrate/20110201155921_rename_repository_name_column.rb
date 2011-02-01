class RenameRepositoryNameColumn < ActiveRecord::Migration
  def self.up
    rename_column :repositories, :name, :project_name
  end

  def self.down
    rename_column :repositories, :project_name, :name
  end
end
