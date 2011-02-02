class RemoveGravatarIdFromUser < ActiveRecord::Migration
  def self.up
    remove_column :users, :gravatar_id
  end

  def self.down
    add_column :users, :gravatar_id, :string
  end
end
