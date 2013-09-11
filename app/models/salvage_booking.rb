class SalvageBooking < ActiveRecord::Base
  belongs_to :booking
  
  # after_create :create_accounting_entry
  
  
  def self.create_object(params)
    new_object = self.new
    new_object.booking_id = params[:booking_id]
    new_object.salvaged_datetime = params[:salvage_datetime]
    if new_object.save 
      new_object.create_accounting_entry
    end
    return new_object 
  end
  
  def create_accounting_entry 
    
    # transaction_1: debit the unearned revenue
    # transaction_4: credit to the other_revenue 
    unearned_revenue_booking_downpayment_account = Account.field_booking_downpayment_account
    salvaged_downpayment_revenue_account = Account.salvaged_downpayment_revenue_account
    
    
    ta = TransactionActivity.create_object({
      :transaction_datetime => self.salvaged_datetime,
      :description => "Salvage Downpayment " ,
      :transaction_source_id => self.id , 
      :transaction_source_type => self.class.to_s 
    })
    
    
    
    TransactionActivityEntry.create_update_or_delete_transaction_entry( 
      ta, 
      nil ,
      self.booking.downpayment_amount ,  
      unearned_revenue_booking_downpayment_account, 
      NORMAL_BALANCE[:debit]
    )
    
    TransactionActivityEntry.create_update_or_delete_transaction_entry( 
      ta, 
      nil ,
      self.booking.downpayment_amount ,  
      salvaged_downpayment_revenue_account, 
      NORMAL_BALANCE[:credit]
    )
    
    ta.confirm 
  end
  
  def delete_object
    ta = TransactionActivity.where(
      :transaction_source_id => self.id , 
      :transaction_source_type => self.class.to_s
    )
    
    return if ta.nil? 
    
    ta.unconfirm 
    ta.internal_delete_object
    
  end
end
