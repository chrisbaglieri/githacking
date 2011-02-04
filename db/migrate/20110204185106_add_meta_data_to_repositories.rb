class AddMetaDataToRepositories < ActiveRecord::Migration
  def self.up
    add_column :repositories, :meta_data, :text
  end

  def self.down
    remove_column :repositories, :meta_data
  end
end
