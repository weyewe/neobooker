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
    
    self.transaction_activity_entries.each {|x| x.destroy }
    self.destroy  
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
    self.save 
  end
  
  def total_debit
    
    self.transaction_activity_entries.where(:entry_case => TRANSACTION_ACTIVITY_ENTRY_CASE[:debit]).sum("amount")
  end
  
  def total_credit
    self.transaction_activity_entries.where(:entry_case => TRANSACTION_ACTIVITY_ENTRY_CASE[:credit]).sum("amount")
  end 
  
  # can only be called from the business rule 
  
  def internal_object_update(params)
  end
  
  def internal_object_destroy
  end
  
end
