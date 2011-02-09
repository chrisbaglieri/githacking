class CreateIssues < ActiveRecord::Migration
  def self.up
    create_table :issues do |t|
      t.string    :gravatar_id,       :null => false
      t.decimal   :position,          :null => false
      t.integer   :number,            :null => false, :default => 0
      t.integer   :votes,             :null => false, :default => 0
      t.integer   :comments,          :null => false, :default => 0
      t.text      :body,                              :default => ""
      t.text      :title,                             :default => ""
      t.string    :user,              :null => false
      t.string    :state,             :null => false
      t.timestamp :closed_at
      t.timestamp :created_at_github, :null => false
      t.timestamp :updated_at_github, :null => false

      t.references :repository

      t.timestamps
    end
  end

  def self.down
    drop_table :issues
  end
end
