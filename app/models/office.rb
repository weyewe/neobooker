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
  
  
  validates_presence_of :main_email
  validates_uniqueness_of :main_email 
  validates_presence_of :starter_password
  validates_presence_of :name 
  
  validate :valid_main_email
  
  def valid_main_email
    return if self.persisted? 
    
    user = User.find_by_email self.main_email
    
    if user.present?
      self.errors.add(:main_email, "Sudah ada email terdaftar")
      return self 
    end
  end
  
  def self.create_registration_object(params)
    new_object = self.new 
    new_object.is_confirmed        = params[:is_confirmed       ]
    new_object.is_demo             = params[:is_demo       ]
    new_object.main_email          = params[:main_email       ]
    new_object.starter_password    = params[:starter_password ]
    new_object.name                = params[:name             ]
    new_object.description         = params[:description      ]
    new_object.code                = params[:code             ]
    
    if new_object.save 
      Account.setup_business( new_object )
      
      new_object.users.create_main_user(  
        :name => new_object.name, 
        :email => new_object.main_email ,
        :password => new_object.starter_password, 
        :password_confirmation => new_object.starter_password
      ) 
    end
    
    return new_object 
  end
  
  def main_user
    User.find_by_email self.main_email
  end
  
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
