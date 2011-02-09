class CreateLabels < ActiveRecord::Migration
    create_table :labels do |t|
      t.string     :name, :null => false
      t.references :issue
      
      t.timestamps
    end

    ['bitesize', 'easy', 'medium', 'hard'].each do |n|
      Label.create :name => n
    end
end
