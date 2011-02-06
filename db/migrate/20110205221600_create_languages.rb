class CreateLanguages < ActiveRecord::Migration
  def self.up
    create_table :languages do |t|
      t.string  :name,  :null => false
      t.integer :bytes, :null => false, :default => 0
      t.references :repository

      t.timestamps
    end
  end

  def self.down
    drop_table :languages
  end
end
