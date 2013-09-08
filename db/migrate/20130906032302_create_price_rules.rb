class CreatePriceRules < ActiveRecord::Migration
  def change
    create_table :price_rules do |t|
      t.integer :hour_start 
      t.integer :hour_end 
      
      t.boolean :is_sunday      , :default => false 
      t.boolean :is_monday      , :default => false 
      t.boolean :is_tuesday     , :default => false 
      t.boolean :is_wednesday      , :default => false 
      t.boolean :is_thursday    , :default => false 
      t.boolean :is_friday      , :default => false 
      t.boolean :is_saturday    , :default => false 
      
      t.decimal :amount,  :default        => 0,  :precision => 12, :scale => 2 
      
      t.integer :rule_case, :default => PRICE_RULE_CASE[:specific]
      
      t.integer :calendar_id
      
      t.boolean :is_active, :default => true 
      t.datetime :deactivated_at 
      
      
      t.timestamps
    end
  end
end
