class CreatePriceDetails < ActiveRecord::Migration
  def change
    create_table :price_details do |t|
      
      t.integer :booking_id 
      t.integer :price_rule_id 
      
      t.decimal :amount,  :default        => 0,  :precision => 9, :scale => 2 
      t.integer :number_of_hours 

      t.timestamps
    end
  end
end
