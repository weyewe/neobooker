class CreateTransactionActivityEntries < ActiveRecord::Migration
  def change
    create_table :transaction_activity_entries do |t|
      t.integer :transaction_activity_id 
      t.integer :account_id
      
      t.integer :entry_case # TRANSACTION_ACTIVITY_ENTRY_CASE[:debit] or [:credit]
      t.decimal :amount, :default        => 0,  :precision => 14, :scale => 2
      
      t.boolean :is_confirmed , :default => false 
      
      t.boolean :is_bank_transaction, :default => false 
      
      t.timestamps
    end
  end
end
