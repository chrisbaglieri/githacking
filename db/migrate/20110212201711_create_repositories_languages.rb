class CreateRepositoriesLanguages < ActiveRecord::Migration
  def self.up
    create_table :repositories_languages, :id => false do |t|
      t.references :repository, :null => false
      t.references :language, :null => false
    end

    remove_column :languages, :repository_id
  end

  def self.down
    drop_table :repositories_languages

    add_column :languages, :repository_id, :integer, :null => false 
  end
end
