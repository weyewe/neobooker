class Calendar < ActiveRecord::Base
  attr_accessible :title, :color, :description 
  has_many :bookings 
  has_many :prices 
  
  validates_presence_of :title, :color 
  
  def self.active_objects
    self.where(:is_deleted => false ) 
  end
  
  def active_price
    self.prices.where(:is_active => true).order("id DESC").first 
  end
  
  def update_price
    self.prices.where(:is_active => true ).each do |price|
      price.is_active = false
      price.save 
    end
    
    new_price = Price.create :calendar_id => self.id , :amount => self.amount  , :is_active => true 
  end
  
  def self.create_object( params ) 
    new_object = self.new 
    new_object.title = params[:title]
    new_object.description = params[:description]
    new_object.color = params[:color]
    new_object.amount = BigDecimal( params[:amount])
    new_object.downpayment_percentage = BigDecimal( params[:downpayment_percentage] || 0 )
    new_object.save
    
    if new_object.errors.size  == 0 
      new_object.update_price 
    end
    
    return new_object 
  end
  
  def update_object( params  ) 
    old_price = self.amount
    new_price = BigDecimal( params[:amount] ) 
    is_price_changed = false 
    if new_price != old_price 
      is_price_changed = true 
    end
    self.title = params[:title]
    self.description = params[:description]
    self.color = params[:color]
    self.amount = new_price 
    self.downpayment_percentage = BigDecimal( params[:downpayment_percentage] || 0)
    self.save 
    
    if is_price_changed
      self.update_price
    end
  end

  def delete_object
    if self.bookings.count ==  0 
      self.destroy
    else
      self.errors.add(:generic_errors, "Sudah ada booking") 
    end
  end
end
