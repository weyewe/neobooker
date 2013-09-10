class TransactionActivity < ActiveRecord::Base
  has_many :transaction_activity_entries 
  validates_presence_of :transaction_datetime 
  
  
  def self.create_object( params ) 
    new_object = self.new 
    new_object.transaction_datetime = params[:transaction_datetime]
    new_object.description = params[:description]
    new_object.save 
    
    return new_object
  end
  
  def update_object( params ) 
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
    self.save
    return self 
  end
  
  def delete_object( params ) 
    if not self.transaction_source_id.nil? 
      self.errors.add(:generic_errors, "Can't modify the automated generated transaction")
      return self 
    end
    
    if self.is_confirmed?
      self.errors.add(:generic_errors, "Can't modify the  confirmed transaction")
      return self 
    end
    
    self.transaction_activity_entries.each {|x| x.destroy }
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
  
end
