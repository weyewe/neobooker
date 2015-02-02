class Office < ActiveRecord::Base
  has_many :accounts
  has_many :bookings
  has_many :calendars
  has_many :customers
  has_many :incomes
  has_many :price_details
  has_many :price_rules
  has_many :prices
  has_many :salvage_bookings
  has_many :transaction_activities
  has_many :transaction_activity_entries 
  has_many :users 
  
  def self.create_object( params )
    
    new_object = self.new 
    new_object.name = params[:name]
    new_object.description = params[:description]
    new_object.code = params[:code] 
    
    if new_object.save
      Account.setup_business( new_object )
    end
    return new_object 
  end
  
  def update_object( params )
    self.name = params[:name]
    self.description = params[:description]
    self.code = params[:code]
    
    
    self.save 
    return self
  end
  
end
