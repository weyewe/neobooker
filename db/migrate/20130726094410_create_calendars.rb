class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|

      t.string :title
      t.text :description 
      t.integer :color  
      
      t.boolean :is_deleted , :default => false 
      
      t.timestamps
    end
  end
end
