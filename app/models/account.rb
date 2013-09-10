class Account < ActiveRecord::Base
  acts_as_nested_set
  
  has_many :transaction_activity_entries
  
  validates_uniqueness_of :name  
  
  
  
  validates_presence_of :name, :account_case 
  
  
  validate :parent_id_present_for_non_base_account
  validate :contra_account_must_be_ledger_account 
  validate :original_account_id_must_present_in_contra_account
  validate :valid_account_case 
  
  
  
  
  def all_base_fields_present? 
    name.present? and
    account_case.present?  and 
    is_contra_account.present?  
  end
  
  
  
  
  def parent_id_present_for_non_base_account
    return if self.is_base_account? 
    
    
 
    if not parent_id.present?  or parent.nil? or  parent.account_case != ACCOUNT_CASE[:group]
      self.errors.add(:parent_id, "Harus ada parent account berupa group account, bukan ledger account")
      return self
    end
  end
  
  def contra_account_must_be_ledger_account
    return if not all_base_fields_present?
    
   
    if is_contra_account? and  account_case != ACCOUNT_CASE[:ledger]
      self.errors.add(:account_case, "Harus berupa ledger account")
      return self 
    end
  end
  
  def original_account_id_must_present_in_contra_account
    return if not all_base_fields_present?
    
    if is_contra_account? and not original_account_id.present? 
      self.errors.add(:original_account_id, "Harus ada account asli untuk membuat contra account")
      return self 
    end
  end
  
  def valid_account_case
    return if not all_base_fields_present?
    
    if not [
      ACCOUNT_CASE[:group],
      ACCOUNT_CASE[:ledger]
      ].include?(account_case) 
      
      self.errors.add(:account_case, "Harus ledger atau group")
      return self 
    end
  end
  
   
=begin
  About Contra Account 
  
  1. 
  Cash debit 10M
  capital credit 10M 
  
  2. 
  Machine debit 10M
  Machine debit 10M 
  
  3. 
  AccumulatedDepreciation credit 1M
  MachineDepreciationExpense debit 1M 
  
  4. 
  Total Machine Value is = Machine + AccumulatedDepreciation (debit, contra account) => so it is contra account
                          = 10 - 1 =  9M 
                          
  
  # so, in the transaction activity, what will the total debit be?
  self.transaction_activity_entries.where(:entry_case => :debit).sum("amount")
  
  the total_credit
  self.transaction_activity_entries.where(:entry_case => :credit).sum("amount")
=end
  
=begin
  Creating Generic Account
=end

  def parent 
    self.class.where(:id => self.parent_id).first 
  end
  
  
  
  
  def update_normal_balance
    return if self.is_base_account? 
    
    if not self.is_contra_account? 
      self.normal_balance = self.parent.normal_balance
    else
      self.normal_balance = NORMAL_BALANCE[:credit] if self.parent.normal_balance == NORMAL_BALANCE[:debit]
      self.normal_balance = NORMAL_BALANCE[:debit] if self.parent.normal_balance == NORMAL_BALANCE[:credit]
    end
    
    # no difference at all 
    
    # self.normal_balance = self.parent.normal_balance
    
    self.classification = self.parent.classification
    
    self.save 
  end

  def self.create_object(params, is_include_code)
    
    new_object                           = self.new 
    new_object.name                      = params[:name]
    new_object.parent_id                 = params[:parent_id]
    new_object.account_case              = params[:account_case]
    new_object.is_contra_account         = params[:is_contra_account]
    new_object.original_account_id       = params[:original_account_id]
    
    if is_include_code
      new_object.code = params[:code]
    end
    


    if new_object.save
      new_object.update_normal_balance
    end
    
    return new_object
    
  end
  
  def update_object( params, is_include_code ) 
    if self.is_base_account? 
      self.errors.add(:generic_errors, "Base Account tidak dapat di update")
      return self 
    end
    
    self.name                      = params[:name]
    self.parent_id                 = params[:parent_id]
    self.account_case              = params[:account_case]
    self.is_contra_account         = params[:is_contra_account]
    self.original_account_id       = params[:original_account_id]
    
    if is_include_code
      self.code = params[:code]
    end


    if self.save
      self.update_normal_balance
    end
    return self
  end
  
  def has_transaction_activities_from_child_account?
    children_id_list = self.descendants.map{|x| x.id }
    TransactionActivityEntry.where(:account_id => children_id_list).count != 0
  end
  
  def has_children_of_business_objects_account?
    self.descendants.where{ code.not_eq nil }.count != 0 
  end
  
  def destroy_child_accounts
    self.descendants.each do |x|
      x.destroy  
    end
  end
  
  def delete_object 
    if self.is_base_account?
      self.errors.add(:generic_errors, "Tidak dapat menghapus base account")
      return self 
    end
    
    if self.has_children_of_business_objects_account?
      self.errors.add(:generic_errors, "Tidak dapat menghapus account ini")
      return self 
    end
    
    
    if self.account_case == ACCOUNT_CASE[:ledger] and
        self.transaction_activity_entries.count != 0 
      self.errors.add(:generic_errors, "Tidak dapat dihapus karena ada posting berdasar akun ini")
      return self 
    else
      self.destroy 
    end
    
    if self.account_case == ACCOUNT_CASE[:group] and
      self.has_transaction_activities_from_child_account?  
      msg = "Tidak dapat dihapus karena sudah ada posting berdasar ledger dari akun ini"
      self.errors.add(:generic_errors, msg )
      return self 
    else
      self.destroy_child_accounts
      self.destroy 
    end
  end
  
  
=begin
  Creating base account
=end

  def self.create_asset 
    new_object = self.new
    new_object.name = "Asset"
    new_object.normal_balance = NORMAL_BALANCE[:debit]
    new_object.account_case = ACCOUNT_CASE[:group]
    new_object.classification = ACCOUNT_CLASSIFICATION[:asset]
    new_object.is_base_account = true 
    new_object.save 
    return new_object
  end
  
  def self.create_expense
    new_object = self.new
    new_object.name = "Expense"
    new_object.normal_balance = NORMAL_BALANCE[:debit]
    new_object.account_case = ACCOUNT_CASE[:group]
    new_object.classification = ACCOUNT_CLASSIFICATION[:expense]
    new_object.is_base_account = true 
    new_object.save
    return new_object
  end
  
  def self.create_revenue
    new_object = self.new
    new_object.name = "Revenue"
    new_object.normal_balance = NORMAL_BALANCE[:credit]
    new_object.account_case = ACCOUNT_CASE[:group]
    new_object.classification = ACCOUNT_CLASSIFICATION[:revenue]
    new_object.is_base_account = true 
    new_object.save
    return new_object
  end
  
  def self.create_liability
    new_object = self.new
    new_object.name = "Liability"
    new_object.normal_balance = NORMAL_BALANCE[:credit]
    new_object.account_case = ACCOUNT_CASE[:group]
    new_object.classification = ACCOUNT_CLASSIFICATION[:liability]
    new_object.is_base_account = true 
    new_object.save
    return new_object
  end
  
  def self.create_equity
    new_object = self.new
    new_object.name = "Equity"
    new_object.normal_balance = NORMAL_BALANCE[:debit]
    new_object.account_case = ACCOUNT_CASE[:group]
    new_object.classification = ACCOUNT_CLASSIFICATION[:equity]
    new_object.is_base_account = true 
    new_object.save
    return new_object
  end




  def self.create_base_objects 
    self.create_asset 
    self.create_expense
    self.create_revenue
    self.create_liability
    self.create_equity 
  end
  
  
=begin
  Update Amount logic
=end

  def update_parent_amount
    return if self.parent_id.nil?
    
    parent_account = self.parent 
    
    parent_normal_balance = parent_account.normal_balance
    # parent_account.amount += parent_account.children.where{
    #   normal_balance.eq parent_normal_balance
    # }.sum("amount")
    
    
    # puts "\n Inside update parent amount"
    # puts "current account :#{self.name}, current_parent_account :#{parent_account.name}"
    # puts "=================> inspect where the child's normal balance == parent's normal balance"
    addition_amount = parent_account.children.where{
      normal_balance.eq parent_normal_balance
    }.sum("amount")
    
    # parent_account.children.where{
    #   normal_balance.eq parent_normal_balance
    # }.each do |x|
    #   puts "===> account #{x.name}, amount: #{x.amount}"
    # end
    
    # puts "updateparent_account. account #{parent_account.name}, addition_amount: #{addition_amount} "
    
    # parent_account.amount -= parent_account.children.where{
    #   normal_balance.not_eq parent_normal_balance
    # }.sum("amount")
    
    deduction_amount = parent_account.children.where{
      normal_balance.not_eq parent_normal_balance
    }.sum("amount")
    
    parent_account.amount = addition_amount - deduction_amount 
    parent_account.save
    
    # puts "final parent_account #{parent_account.name}, deduction_amount: #{deduction_amount}"
    # puts "final parent_account amount : #{parent_account.amount}"
    # parent_account.save 
    parent_account.update_parent_amount
    
  end

  def update_amount_from_posting_confirm(ta_entry)
    # puts "inside the account: #{self.name}"
    multiplicator = 1 
    if ta_entry.entry_case != self.normal_balance 
      multiplicator = -1
    end
    
    self.amount +=  multiplicator * ta_entry.amount 
    
    if self.save 
      # update parents
      self.update_parent_amount
    end
  end
  
  def update_amount_from_posting_unconfirm(ta_entry) 
    multiplicator = -1 
    if ta_entry.entry_case != self.normal_balance 
      multiplicator = 1
    end
    
    self.amount +=  multiplicator * ta_entry.amount 
    # puts "final amount for account: #{self.name} :: #{self.amount}. Addition: #{multiplicator * ta_entry.amount }"

    if self.save 
      # update parents
      # puts "gonna update parent from leaf"
      # puts "***The starter account: #{self.name}"
      self.update_parent_amount
    end
  end
  
  
  
  
  
  
=begin
  Create Cash Drawer account.. Asset > Cash > Cash Drawer 
=end
  def self.asset_account
    self.where(
      :classification => ACCOUNT_CLASSIFICATION[:asset],
      :is_base_account => true 
    ).first 
  end
  
  def self.liability_account
    self.where(
      :classification => ACCOUNT_CLASSIFICATION[:liability],
      :is_base_account => true 
    ).first
  end
  
  def self.revenue_account
    self.where(
      :classification => ACCOUNT_CLASSIFICATION[:revenue],
      :is_base_account => true 
    ).first 
  end
  
  def self.expense_account
    self.where(
      :classification => ACCOUNT_CLASSIFICATION[:expense],
      :is_base_account => true 
    ).first 
  end
  
  def self.equity_account
    self.where(
      :classification => ACCOUNT_CLASSIFICATION[:equity],
      :is_base_account => true 
    ).first 
  end
  
  
  def self.cash_account
    self.where(
      :classification => ACCOUNT_CLASSIFICATION[:asset],
      :is_base_account => false,
      :code => APP_SPECIFIC_ACCOUNT_CODE[:cash]
    ).first
  end
  
  def self.cash_drawer_account
    self.where(
      :classification => ACCOUNT_CLASSIFICATION[:asset],
      :is_base_account => false,
      :code => APP_SPECIFIC_ACCOUNT_CODE[:cash_drawer]
    ).first
  end
  
  def self.field_usage_revenue_account
    self.where(
      :classification => ACCOUNT_CLASSIFICATION[:revenue],
      :is_base_account => false,
      :code => APP_SPECIFIC_ACCOUNT_CODE[:field_usage_revenue]
    ).first
  end
  
  def self.salvaged_downpayment_revenue_account
    self.where(
      :classification => ACCOUNT_CLASSIFICATION[:revenue],
      :is_base_account => false,
      :code => APP_SPECIFIC_ACCOUNT_CODE[:salvaged_downpayment_revenue]
    ).first
  end
  
  def self.field_booking_downpayment_account
    self.where(
      :classification => ACCOUNT_CLASSIFICATION[:liability],
      :is_base_account => false,
      :code => APP_SPECIFIC_ACCOUNT_CODE[:unearned_revenue_booking_downpayment]
    ).first
  end
  
  
  
  def self.create_cash_account
    new_object = self.new
    new_object.name = "Cash"
    new_object.parent_id = self.asset_account.id 
    new_object.normal_balance = NORMAL_BALANCE[:debit]
    new_object.account_case = ACCOUNT_CASE[:group]
    new_object.classification = ACCOUNT_CLASSIFICATION[:asset]
    new_object.code = APP_SPECIFIC_ACCOUNT_CODE[:cash]
    new_object.save
    return new_object 
  end
  
  def self.create_downpayment_account
    new_object = self.new
    new_object.name = "Downpayment"
    new_object.parent_id = self.liability_account.id 
    new_object.normal_balance = NORMAL_BALANCE[:credit]
    new_object.account_case = ACCOUNT_CASE[:ledger]
    new_object.classification = ACCOUNT_CLASSIFICATION[:liability]
    new_object.code = APP_SPECIFIC_ACCOUNT_CODE[:unearned_revenue_booking_downpayment]
    new_object.save
    return new_object
  end
  
  
  
  
  
  
  
  def self.create_business_specific_objects 
    cash_account = self.create_cash_account
    self.create_object({
      :name => "Cash Drawer",
      :parent_id => cash_account.id , 
      :account_case => ACCOUNT_CASE[:ledger],
      :is_contra_account => false,
      :original_account_id => nil,
      :code  => APP_SPECIFIC_ACCOUNT_CODE[:cash_drawer]
    },true
      
    )
    
    revenue_account = self.revenue_account 
    self.create_object({
      :name => "Field Usage Revenue",
      :parent_id => revenue_account.id , 
      :account_case => ACCOUNT_CASE[:ledger],
      :is_contra_account => false,
      :original_account_id => nil,
      :code  => APP_SPECIFIC_ACCOUNT_CODE[:field_usage_revenue]
    },true
      
    )
    
    self.create_object({
      :name => "Salvaged Downpayment Revenue",
      :parent_id => revenue_account.id , 
      :account_case => ACCOUNT_CASE[:ledger],
      :is_contra_account => false,
      :original_account_id => nil,
      :code  => APP_SPECIFIC_ACCOUNT_CODE[:salvaged_downpayment_revenue]
    },true
      
    )
    
    # unearned revenue 
    # downpayment_account = self.create_downpayment_account # part of liability account => unearned revenue 
    liability_account = self.liability_account
    self.create_object({
      :name => "Field Booking Downpayment",
      :parent_id => liability_account.id , 
      :account_case => ACCOUNT_CASE[:ledger],
      :is_contra_account => false,
      :original_account_id => nil,
      :code  => APP_SPECIFIC_ACCOUNT_CODE[:unearned_revenue_booking_downpayment]
    }, true
    )
  end
  
  def self.create_temporary_migration_objects
    
  
    new_object = self.new
    new_object.name = "Temporary Debit Account"
    new_object.normal_balance = NORMAL_BALANCE[:debit]
    new_object.account_case = ACCOUNT_CASE[:ledger]
    new_object.classification = ACCOUNT_CLASSIFICATION[:temporary_debit]
    new_object.is_base_account = true 
    new_object.is_temporary_account = true 
    new_object.save 
    
    new_object = self.new
    new_object.name = "Temporary Credit Account"
    new_object.normal_balance = NORMAL_BALANCE[:credit]
    new_object.account_case = ACCOUNT_CASE[:ledger]
    new_object.classification = ACCOUNT_CLASSIFICATION[:temporary_credit]
    new_object.is_base_account = true 
    new_object.is_temporary_account = true 
    new_object.save  
  end
  
  def self.setup_business
    self.create_base_objects
    self.create_business_specific_objects
    self.create_temporary_migration_objects 
  end
  
  
  
  def has_created_initial_amount?
    not self.initial_amount_transaction_activity.nil?
  end
  
  
  
  def initial_amount_transaction_activity
    TransactionActivity.where(
      :transaction_source_id => self.id, 
      :transaction_source_type => self.class.to_s 
    ).first
  end
  
  def self.temporary_credit_account
    Account.where(:classification => ACCOUNT_CLASSIFICATION[:temporary_credit]).first
  end
  
  def self.temporary_debit_account
    Account.where(:classification => ACCOUNT_CLASSIFICATION[:temporary_debit]).first
  end
  
  
  # for migration 
  
  def temporary_account
    if self.normal_balance == NORMAL_BALANCE[:debit]
      return self.class.temporary_credit_account
    else
      return self.class.temporary_debit_account
    end
  end
  
  def create_initial_amount(params)
    if not self.leaf? 
      self.errors.add(:generic_errors, "Group Account tidak bisa setup jumlah awal. Gunakan Ledger Account!")
      return self 
    end
    
    
    
    self.initial_amount = BigDecimal( params[:initial_amount] || 0 ) 
    
    transaction_activity = nil 
    
    if self.save 
      
      if self.has_created_initial_amount?
        # update the transaction_activity_entry
        transaction_activity = initial_amount_transaction_activity
        transaction_activity.unconfirm 
        
        
        transaction_activity.transaction_activity_entries.each do |ta_entry|
          ta_entry.destroy 
        end
      else
        
        transaction_activity = TransactionActivity.create_object(
          :transaction_datetime => DateTime.now,
          :description => "Migrasi Akun #{self.name}",
          :transaction_source_id => self.id ,
          :transaction_source_type => self.class.to_s
        )
         
      end 
      
      transaction_activity.create_initial_migration 
      
      transaction_activity.reload 
      transaction_activity.confirm
      
    end
    return transaction_activity
  end
end
