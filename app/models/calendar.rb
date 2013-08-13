class Calendar < ActiveRecord::Base
  attr_accessible :title, :color, :description 
  has_many :bookings 
  has_many :prices 
  
  validates_presence_of :title, :color, :amount, :downpayment_percentage
  
  validate :amount_must_be_more_than_0
  validate :downpayment_percentage_must_be_logical
  
  def amount_must_be_more_than_0
    return if not self.amount.present? 
    
    if self.amount < BigDecimal('0')
      self.errors.add(:amount, "Harus lebih besar dari 0")
    end
  end
  
  def downpayment_percentage_must_be_logical
    return if not self.downpayment_percentage.present? 
    
    if self.downpayment_percentage < BigDecimal('0') or self.downpayment_percentage > BigDecimal("100")
      self.errors.add(:downpayment_percentage, "Harus di antara 0 sampai dengan 100")
    end
  end
  
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
    # puts "==============\n"*10
    # puts "Inside create object (calendar)"
    # puts "The amount: #{params[:amount]}"
    # puts "The DP percentage: #{params[:downpayment_percentage]}"
    new_object.amount = BigDecimal( params[:amount])
    new_object.downpayment_percentage = BigDecimal( params[:downpayment_percentage] || 0 )
    new_object.save
    
    
    
    if new_object.errors.size  == 0 
      new_object.update_price 
      new_object.adjust_color
    end
    
    return new_object 
  end
  
  def adjust_color
    if color < 1 or color > 32 
      self.color = 5 
    end
    
    self.save
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
      self.adjust_color 
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
