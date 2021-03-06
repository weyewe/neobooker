class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      # it has to be a tree 

      t.string :name
      t.integer :parent_id
      t.integer :lft
      t.integer :rgt
      t.integer :depth # this is optional.
      
      # we need total_amount
      # we need contra_account_id 
      # we need is_contra_account
      # we need parent_contra_account_id 
      # we need normal_balance  # debit or credit 
      
      t.decimal :amount , :default        => 0,  :precision => 14, :scale => 2 # 10*12 999 * 10^9
      t.decimal :initial_amount , :default        => 0,  :precision => 14, :scale => 2 # 10*12 999 * 10^9
      t.integer :last_update_transaction_activity_entry_id 
      
      t.boolean :is_contra_account, :default => false 
      t.integer :original_account_id  
      
      
      
      t.integer :normal_balance , :default => NORMAL_BALANCE[:debit]
      
      t.integer :account_case , :default => ACCOUNT_CASE[:ledger]
      
      t.integer :classification, :default => ACCOUNT_CLASSIFICATION[:asset]
      
      t.boolean :is_base_account, :default => false 
      # contra account will take place @balance sheet 
      
      t.boolean :is_temporary_account , :default => false 
      
      
      t.string :code
      
      t.timestamps
    end
  end
end
