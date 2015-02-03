class SalvageBooking < ActiveRecord::Base
  belongs_to :office
  belongs_to :booking
  
  # after_create :create_accounting_entry
  
  
  def self.create_object(params)
    new_object = self.new
    new_object.booking_id = params[:booking_id]
    new_object.salvaged_datetime = params[:salvaged_datetime]
    new_object.office_id = params[:office_id]
    if new_object.save 
      
      # puts "\n\n\n"
      # puts "**** The salvaged is created"
      new_object.create_accounting_entry
    end
    return new_object 
  end
  
  def create_accounting_entry 
    
    # transaction_1: debit the unearned revenue
    # transaction_4: credit to the other_revenue 
    unearned_revenue_booking_downpayment_account = Account.field_booking_downpayment_account(self.office)
    salvaged_downpayment_revenue_account = Account.salvaged_downpayment_revenue_account(self.office)
    
    # puts "create transaction_activity"
    
    ta = TransactionActivity.create_object({
      :transaction_datetime => self.salvaged_datetime,
      :description => "Salvage Downpayment " ,
      :transaction_source_id => self.id , 
      :transaction_source_type => self.class.to_s 
    }, true )
    
    # puts "The errors: #{ta.errors.size}"
    # ta.errors.messages.each {|x| puts x }
    
    
    
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
    ).first 
    
    return if ta.nil? 
    
    ta.unconfirm 
    ta.internal_delete_object
    
  end
end
