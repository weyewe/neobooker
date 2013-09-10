class CreateTransactionActivities < ActiveRecord::Migration
  def change
    create_table :transaction_activities do |t|
      
      t.integer :transaction_source_id 
      t.string :transaction_source_type 

      t.datetime :transaction_datetime 
      t.text :description 

      t.decimal :amount, :default        => 0,  :precision => 14, :scale => 2

      # debit amount must be equal to credit amount.. ahahaha awesome shite 
      t.boolean :is_confirmed  # can only be confirmed if debit == credit.. hahaha.

      t.timestamps
    end
  end
end
