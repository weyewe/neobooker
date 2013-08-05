class Booking < ActiveRecord::Base
  belongs_to :calendar 
  belongs_to :customer
  belongs_to :price 
  
  attr_accessible :start_datetime, :number_of_hours,
          :title, :calendar_id , :customer_id, :price_id 
          
  validates_presence_of :start_datetime, :number_of_hours , :title , :customer_id , :calendar_id 
  
  validate :valid_customer_id
  validate :valid_calendar_id
  validate :valid_number_of_hours
  
  def valid_customer_id
    return if not customer_id.present? 
    if customer_id == 0 
      self.errors.add(:customer_id , "Customer Harus Dipilih")
    end
  end
  
  def valid_calendar_id
    return if not calendar_id.present? 
    if calendar_id == 0 
      self.errors.add(:calendar_id , "Fasilitas Harus Dipilih")
    end
  end
  
  def valid_number_of_hours
    return if not self.number_of_hours.present? 
    
    if number_of_hours <= 0 
      self.errors.add(:number_of_hours, "Durasi harus lebih besar dari 0")
    end
    
  end
  
  def self.active_objects
    self
  end
  
  
  def update_end_datetime
    return self.start_datetime if not self.number_of_hours.present? 
    self.end_datetime = self.start_datetime + self.number_of_hours.hours
    self.save 
  end
  
  def update_price
    self.price_id = self.calendar.active_price.id  
    self.save  
  end
  
  
  
  
   
  
  def self.create_object( params ) 
    new_object = self.new 
    new_object.start_datetime = params[:start_datetime]
    new_object.number_of_hours = params[:number_of_hours]
    new_object.title = params[:title]
    new_object.calendar_id = params[:calendar_id]
    new_object.customer_id = params[:customer_id]
    
    if new_object.save 
      new_object.update_end_datetime 
      new_object.update_price 
    end
    return new_object
  end
  
  def update_object(params)
    self.start_datetime = params[:start_datetime]
    self.number_of_hours = params[:number_of_hours]
    self.title = params[:title]
    self.calendar_id = params[:calendar_id]
    self.customer_id = params[:customer_id]
    
   
    if self.save 
      self.update_end_datetime
    end
    return self
  end
  
  
  # endDate = ( now + 1.day ).to_date.to_datetime
  # startDate = now.to_date.to_datetime
  
  def self.bookings_in_between(startDate, endDate)
    self.where{
      ( start_datetime.lte endDate ) &
      (
        (
          ( end_datetime.gte endDate ) &
          ( start_datetime.gte startDate)
        ) |
        (
          ( start_datetime.gte startDate) & 
          ( end_datetime.lte endDate )
        ) |
        (
          ( start_datetime.lte startDate) & 
          ( end_datetime.lte endDate ) &
          ( end_datetime.gte startDate)
        )  |
        (
          ( start_datetime.lte startDate) & 
          ( end_datetime.gte endDate)
        )
      )
    }
  end
  
  def total_price
    self.number_of_hours * self.price.amount 
  end
  
  def downpayment_amount 
    (( 100 - self.discount)/100.to_f) * self.total_price * (self.calendar.downpayment_percentage/100.to_f)
  end
  
  def remaining_amount 
    self.total_price - self.downpayment_amount 
  end
end
