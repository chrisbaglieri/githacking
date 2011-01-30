class AddGravatarIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :gravatar_id, :string
  end

  def self.down
    remove_column :users, :gravatar_id
  end
end
