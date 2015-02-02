class TransactionActivity < ActiveRecord::Base
  belongs_to :office
  has_many :transaction_activity_entries 
  validates_presence_of :transaction_datetime 
  
  
  def self.create_object( params, is_automated_transaction ) 
    new_object = self.new 
    new_object.transaction_datetime = params[:transaction_datetime]
    new_object.description = params[:description]
    
    if is_automated_transaction
      new_object.transaction_source_id = params[:transaction_source_id]
      new_object.transaction_source_type = params[:transaction_source_type]
    end
    
    new_object.save 
    
    return new_object
  end
  
  def update_object( params , is_automated_transaction ) 
    if not self.transaction_source_id.nil? 
      self.errors.add(:generic_errors, "Can't modify the automated generated transaction")
      return self 
    end
    
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Can't modify the  confirmed transaction")
      return self 
    end
    
    self.transaction_datetime = params[:transaction_datetime]
    self.description = params[:description]
    
    if is_automated_transaction
      self.transaction_source_id = params[:transaction_source_id]
      self.transaction_source_type = params[:transaction_source_type]
    end
    
    self.save
    return self 
  end
  
  def delete_object 
    if not self.transaction_source_id.nil? 
      self.errors.add(:generic_errors, "Can't modify the automated generated transaction")
      return self 
    end
    
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Can't modify the  confirmed transaction")
      return self 
    end
    
    self.transaction_activity_entries.each {|x| x.delete_object }
    self.destroy  
  end
  
  def internal_delete_object
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Can't modify the  confirmed transaction")
      return self
    end
    
    self.transaction_activity_entries.each { |x| x.internal_delete_object}
    self.destroy 
  end
  
  
  
  def update_affected_accounts_due_to_confirmation
    self.transaction_activity_entries.each do |ta_entry|
      account = ta_entry.account 
      account.update_amount_from_posting_confirm(ta_entry)
    end
  end
  
  def update_affected_accounts_due_to_un_confirmation
    self.transaction_activity_entries.each do |ta_entry|
      account = ta_entry.account 
      account.update_amount_from_posting_unconfirm(ta_entry)
    end
  end
  
  def confirm
    if self.transaction_activity_entries.count == 0 
      self.errors.add(:generic_errors, "Tidak ada posting. Tidak bisa konfirmasi")
      return self
    end
    
    if self.total_debit != self.total_credit
      self.errors.add(:generic_errors, "Total debit (#{total_debit}) tidak sama dengan total credit (#{total_credit})")
      return self 
    end
    
    if self.total_debit == BigDecimal('0')  
      self.errors.add(:generic_errors, "Total jumlah transaksi tidak boleh 0")
      return self 
    end
    
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Sudah dikonfirmasi")
      return self 
    end
    
    self.is_confirmed = true
    self.amount = self.total_credit 
    if self.save 
      self.update_affected_accounts_due_to_confirmation
    end
  end
  
  
  # to be called in the controller 
  def external_unconfirm
    if not self.transaction_source_id.nil? 
      self.errors.add(:generic_errors, "Can't modify the automated generated transaction")
      return self 
    end
    
    self.is_confirmed = false 
    if self.save
      self.update_affected_accounts_due_to_un_confirmation
    end
  end
  
  def unconfirm
    self.is_confirmed = false 
    if self.save
      self.update_affected_accounts_due_to_un_confirmation
    end
  end
  
  def total_debit
    self.transaction_activity_entries.where(:entry_case => NORMAL_BALANCE[:debit]).sum("amount")
  end
  
  def total_credit
    self.transaction_activity_entries.where(:entry_case => NORMAL_BALANCE[:credit]).sum("amount")
  end 
  
  # can only be called from the business rule 
  
  def internal_object_update(params)
  end
  
  def internal_object_destroy
  end
  
=begin
  FOR MIGRATION
=end

  def create_initial_migration
    account = Account.find_by_id self.transaction_source_id 
    
    initial_amount = account.initial_amount
    temporary_account = account.temporary_account
    
    entry_case = 0
    migration_amount = initial_amount
    temporary_entry_case = temporary_account.normal_balance
    entry_case = account.normal_balance 
     
    if initial_amount < BigDecimal('0')
      entry_case = NORMAL_BALANCE[:debit] if account.normal_balance == NORMAL_BALANCE[:credit]
      entry_case = NORMAL_BALANCE[:credit] if account.normal_balance == NORMAL_BALANCE[:credit]
      migration_amount = -1 * initial_amount 
      
      temporary_entry_case = NORMAL_BALANCE[:debit] if temporary_account.normal_balance == NORMAL_BALANCE[:credit]
      temporary_entry_case = NORMAL_BALANCE[:credit] if temporary_account.normal_balance == NORMAL_BALANCE[:debit]
    end
    
    current_account_migration = TransactionActivityEntry.create_object(
      :transaction_activity_id =>  self.id,
      :account_id => account.id ,
      :entry_case => entry_case ,
      :amount =>  migration_amount
    
    )
    
    temporary_account_migration = TransactionActivityEntry.create_object(
      :transaction_activity_id =>  self.id,
      :account_id => temporary_account.id ,
      :entry_case => temporary_entry_case ,
      :amount =>  migration_amount
    )
  
  end
  
end
