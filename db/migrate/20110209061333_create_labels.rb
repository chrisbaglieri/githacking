class CreateLabels < ActiveRecord::Migration
    create_table :labels do |t|
      t.string     :name, :null => false
      
      t.timestamps
    end
end
