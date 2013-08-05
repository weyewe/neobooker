class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.integer :calendar_id  
      t.decimal :amount,  :default        => 0,  :precision => 9, :scale => 2 
      t.boolean :is_active, :default => false 
      # 10^7
      t.timestamps
    end
  end
end
