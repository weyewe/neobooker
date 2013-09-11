=begin
  Bridging Object does the journal posting => Touches the account directly 
=end

class Income < ActiveRecord::Base
  attr_accessible :income_source_id, 
                  :income_source_type,
                  :amount ,
                  :case ,
                  :transaction_datetime ,
                  :code
                  
  belongs_to :income_source, :polymorphic => true 
  
  has_many :transaction_activities, :as => :transaction_source 
  
  # after_create :update_accounting
  
  
  def self.create_booking_confirmation_income( params ) 
    income = Income.create(
        :income_source_type   => params[:income_source_type  ],
        :income_source_id     => params[:income_source_id    ],
        :amount               => params[:amount              ],
        :case                 => params[:case                ],
        :transaction_datetime => params[:transaction_datetime],
        :code                 => params[:code                ]
    )            
      
      
    # create unearned revenue  : credit
    # create cash_drawer   : debit 
    cash_drawer_account = Account.cash_drawer_account
    unearned_revenue_booking_downpayment_account = Account.field_booking_downpayment_account
    
      
    ta = TransactionActivity.create_object({
      :transaction_datetime => income.income_source.confirmed_datetime ,
      :description => "Booking Downpayment" ,
      :transaction_source_id => income.id , 
      :transaction_source_type => income.class.to_s 
    })
     
    transaction_1 = ta.transaction_activity_entries.where(
      :account_id => unearned_revenue_booking_downpayment_account.id 
    ).first
    
    transaction_3 = ta.transaction_activity_entries.where(
      :account_id => cash_drawer_account.id 
    ).first
    
    

    TransactionActivityEntry.create_update_or_delete_transaction_entry( 
      ta, 
      transaction_1,
      income.income_source.downpayment_amount ,  
      unearned_revenue_booking_downpayment_account, 
      NORMAL_BALANCE[:credit]
    )
    
    TransactionActivityEntry.create_update_or_delete_transaction_entry( 
      ta, 
      transaction_3,
      income.income_source.downpayment_amount ,  
      cash_drawer_account, 
      NORMAL_BALANCE[:debit]
    )
      
    
    ta.confirm 
    
    return income
    
  end
  
  
 
  
  def self.create_remaining_payment_income(params)
    
    
    income = Income.create(
        :income_source_type   => params[:income_source_type  ],
        :income_source_id     => params[:income_source_id    ],
        :amount               => params[:amount              ],
        :case                 => params[:case                ],
        :transaction_datetime => params[:transaction_datetime],
        :code                 => params[:code                ]
    )
    
    income_source = income.income_source
    
    # 1. debit the unearned revenue (equal to the amount of confirmation payment)
    # 2. credit the revenue for usage  ( unearned revenue + cash from remaining payment)
    # 3. debit the cash_drawer 
    
    unearned_revenue_booking_downpayment_account = Account.field_booking_downpayment_account
    cash_drawer_account = Account.cash_drawer_account 
    field_usage_revenue_account = Account.field_usage_revenue_account
    
    ta = TransactionActivity.create_object({
      :transaction_datetime => income_source.paid_datetime  ,
      :description => "Field Usage Payment" ,
      :transaction_source_id => income.id , 
      :transaction_source_type => income.class.to_s 
    })
    
    transaction_1 = ta.transaction_activity_entries.where(
      :account_id => unearned_revenue_booking_downpayment_account.id 
    ).first 
    
    transaction_2 = ta.transaction_activity_entries.where(
      :account_id => field_usage_revenue_account.id 
    ).first
    
    transaction_3 = ta.transaction_activity_entries.where(
      :account_id => cash_drawer_account.id 
    ).first
    
    amount_transaction_1  = BigDecimal('0')
    amount_transaction_2 = BigDecimal('0')
    amount_transaction_3 = BigDecimal('0') 
    
    
    
      
    
    #   Accounting for the porting of unearned revenue to field_usage amount 
    # transaction_1 debit amount  of unearned revenue 
    # transaction_2 credit amount 
    amount_transaction_1 += income_source.downpayment_amount 
    amount_transaction_2 += income_source.downpayment_amount 
    
    # Accounting for debit cash withdrawal and credit field_usage revenue 
    amount_transaction_2 += income_source.remaining_amount
    amount_transaction_3 += income_source.remaining_amount 
    
    TransactionActivityEntry.create_update_or_delete_transaction_entry( 
      ta, 
      transaction_1,
      amount_transaction_1 ,  
      unearned_revenue_booking_downpayment_account, 
      NORMAL_BALANCE[:debit]
    )
    
    TransactionActivityEntry.create_update_or_delete_transaction_entry( 
      ta, 
      transaction_2,
      amount_transaction_2 ,  
      field_usage_revenue_account, 
      NORMAL_BALANCE[:credit]
    )
    
    TransactionActivityEntry.create_update_or_delete_transaction_entry( 
      ta, 
      transaction_3,
      amount_transaction_3 ,  
      cash_drawer_account, 
      NORMAL_BALANCE[:debit]
    ) 
  
    ta.confirm
    
    return income 
  end
  
  
  
  def update_amount( new_amount ) 
    self.amount = new_amount 
    self.save 
    
    ta = TransactionActivity.where(
      :transaction_source_id => self.id, 
      :transaction_source_type => self.class.to_s 
    )
    
    
    
    ta.unconfirm 
    
    
    if self.case == INCOME_CASE[:downpayment]
      
      # transaction_1: credit the unearned revenue (equal to the amount of confirmation payment)
      # transaction_3: debit the cash_drawer
      
      cash_drawer_account = Account.cash_drawer_account
      unearned_revenue_booking_downpayment_account = Account.field_booking_downpayment_account
    
      ta.reload 
      
      transaction_1 = ta.transaction_activity_entries.where(
        :account_id => unearned_revenue_booking_downpayment_account.id 
      ).first
      
      transaction_3 = ta.transaction_activity_entries.where(
        :account_id => cash_drawer_account.id 
      ).first
      
      
      TransactionActivityEntry.create_update_or_delete_transaction_entry( 
        ta, 
        transaction_1,
        self.income_source.downpayment_amount ,  
        cash_drawer_account, 
        NORMAL_BALANCE[:debit]
      )
      
      TransactionActivityEntry.create_update_or_delete_transaction_entry( 
        ta, 
        transaction_3,
        self.income_source.downpayment_amount ,  
        unearned_revenue_booking_downpayment_account, 
        NORMAL_BALANCE[:credit]
      )
      
      ta.confirm
      
    elsif  self.case == INCOME_CASE[:remaining_payment]
      unearned_revenue_booking_downpayment_account = Account.field_booking_downpayment_account
      cash_drawer_account = Account.cash_drawer_account 
      field_usage_revenue_account = Account.field_usage_revenue_account
      
      
      # transaction_1: debit the unearned revenue (equal to the amount of confirmation payment)
      # transaction_2: credit the revenue for usage  ( unearned revenue + cash from remaining payment)
      # transaction_3: debit the cash_drawer
      
      transaction_1 = ta.transaction_activity_entries.where(
        :account_id => unearned_revenue_booking_downpayment_account.id 
      ).first 
      
      transaction_2 = ta.transaction_activity_entries.where(
        :account_id => field_usage_revenue_account.id 
      ).first
      
      transaction_3 = ta.transaction_activity_entries.where(
        :account_id => cash_drawer_account.id 
      ).first
      
      amount_transaction_1  = BigDecimal('0')
      amount_transaction_2 = BigDecimal('0')
      amount_transaction_3 = BigDecimal('0')
      if self.income_source.downpayment_amount != BigDecimal('0')
        amount_transaction_1 += self.income_source.downpayment_amount 
        amount_transaction_2  += self.income_source.downpayment_amount 
      end
      
      if self.income_source.remaining_amount != BigDecimal('0')
        amount_transaction_3 += self.income_source.remaining_amount 
        amount_transaction_2 += self.income_source.remaining_amount  
      end
      
      
    
      TransactionActivityEntry.create_update_or_delete_transaction_entry( 
        ta, 
        transaction_1,
        amount_transaction_1,  
        unearned_revenue_booking_downpayment_account, 
        NORMAL_BALANCE[:debit]
      )
      
      TransactionActivityEntry.create_update_or_delete_transaction_entry( 
        ta, 
        transaction_2,
        amount_transaction_2,  
        field_usage_revenue_account, 
        NORMAL_BALANCE[:debit]
      )
      
      TransactionActivityEntry.create_update_or_delete_transaction_entry( 
        ta, 
        transaction_3,
        amount_transaction_3,  
        cash_drawer_account, 
        NORMAL_BALANCE[:debit]
      )
    
    end
    
    
    ta.confirm 
  end
  
  
  
  # def create_update_or_delete_transaction_entry(  transaction_activity, transaction_activity_entry, amount , account, entry_case) 
  #   if amount == BigDecimal('0') 
  #     transaction_activity_entry.internal_delete_object if not transaction_activity_entry.nil?
  #   else
  #     if transaction_activity_entry.nil? 
  #       TransactionActivityEntry.create_object(
  #         :transaction_activity_id =>  transaction_activity.id,
  #         :account_id => account.id ,
  #         :entry_case => entry_case,
  #         :amount =>  amount
  #       )
  #     else
  #       transaction_activity_entry.amount = amount 
  #       transaction_activity_entry.save 
  #     end
  #   end  
  # end
  
  
  
  def transaction_activity
    self.transaction_activities.first 
  end
  
  def delete_object
    ta = self.transaction_activity
    return if ta.nil?
      
    
    ta.unconfirm
    ta.internal_delete_object  
    
    self.destroy 
  end
  
  
end
