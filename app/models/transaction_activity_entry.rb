class TransactionActivityEntry < ActiveRecord::Base
  belongs_to :account
  belongs_to :transaction_activity
  
  validate :valid_account_id
  validate :valid_transaction_activity_id 
  validate :valid_entry_case
  validate :valid_amount
  
  
  validates_presence_of :account_id, :entry_case, :amount, :transaction_activity_id 
  
  def all_fields_present?
    account_id.present? and 
    entry_case.present? and 
    amount.present? and 
    transaction_activity_id.present? 
  end
  
  def valid_account_id
    return if not self.all_fields_present? 
    
    begin
      Account.find account_id 
    rescue
      self.errors.add(:account_id, "Harus memilih account") 
      return self 
    end
    
  end
  
  def valid_transaction_activity_id
    return if not self.all_fields_present? 
    
    begin
      TransactionActivity.find transaction_activity_id 
    rescue
      self.errors.add(:transaction_activity_id, "Harus memilih account") 
      return self 
    end
  end
  
  def valid_entry_case
    return if not self.all_fields_present? 
    if not [TRANSACTION_ACTIVITY_ENTRY_CASE[:debit],
      TRANSACTION_ACTIVITY_ENTRY_CASE[:credit]].include?(entry_case)
      self.errors.add(:entry_case, "Harus memilih tipe posting: debit atau credit")
      return self 
    end
  end
  
  def valid_amount
    return if not self.all_fields_present? 
    
    if self.amount <= BigDecimal("0")
      self.errors.add(:amount, "Harus positive")
      return self 
    end
  end
  
  def self.create_object( params)
    new_object = self.new 
    new_object.transaction_activity_id = params[:transaction_activity_id]
    new_object.account_id = params[:account_id]
    new_object.entry_case = params[:entry_case]
    new_object.amount = BigDecimal(params[:amount] || '0') 
    new_object.save 
    
    return new_object
  end
  
  def update_object( params ) 
    if not self.transaction_source_id.nil? 
      self.errors.add(:generic_errors, "Can't modify the automated generated transaction")
      return self 
    end
    
    if self.transaction_activity.is_confirmed?
      self.errors.add(:generic_errors, "Transaksi sudah di konfirmasi. Tidak bisa di update")
      return self 
    end
    
    self.transaction_activity_id = params[:transaction_activity_id]
    self.account_id = params[:account_id]
    self.entry_case = params[:entry_case]
    self.amount = BigDecimal(params[:amount] || '0') 
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
    self.is_confirmed = true 
    self.save 
  end
  
  # can only be called from the business rule 
  
  def internal_object_update(params)
  end
  
  def internal_object_destroy
  end
end
