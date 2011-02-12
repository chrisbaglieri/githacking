class CreateLabelsTags < ActiveRecord::Migration
  def self.up
    create_table :labels_tags, :id => false do |t|
      t.references :issue, :null => false
      t.references :label, :null => false
    end
  end

  def self.down
    drop_table :labels_tags
  end
end
