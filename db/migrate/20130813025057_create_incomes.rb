class CreateIncomes < ActiveRecord::Migration
  def change
    create_table :incomes do |t|
      t.integer :income_source_id 
      t.string  :income_source_type
      
      t.decimal :amount , :default        => 0,  :precision => 11, :scale => 2
      t.integer :case 
      t.datetime :transaction_datetime 
      
      t.string :code 
      
      t.timestamps
    end
  end
end
