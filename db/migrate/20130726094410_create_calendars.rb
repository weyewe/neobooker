class CreateCalendars < ActiveRecord::Migration
  def change
    create_table :calendars do |t|

      t.string :title
      t.text :description 
      t.integer :color  
      
      # the price 
      t.decimal :amount,  :default        => 0,  :precision => 9, :scale => 2 
      
      
      t.decimal :downpayment_percentage, :default        => 0,  :precision => 5, :scale => 2
      
      
      t.boolean :is_deleted , :default => false 
      
      t.timestamps
    end
  end
end
