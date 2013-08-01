class Booking < ActiveRecord::Base
  belongs_to :calendar 
  belongs_to :customer 
  
  attr_accessible :start_datetime, :end_datetime,
          :title, :calendar_id , :customer_id 
          
  validates_presence_of :start_datetime, :end_datetime, :title , :customer_id , :calendar_id 
  
  validate :valid_customer_id
  validate :valid_calendar_id
  
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
  
  def self.active_objects
    self
  end
  
  def self.create_object( params ) 
    new_object = self.new 
    new_object.start_datetime = params[:start_datetime]
    new_object.end_datetime = params[:end_datetime]
    new_object.title = params[:title]
    new_object.calendar_id = params[:calendar_id]
    new_object.customer_id = params[:customer_id]
    
    new_object.save 
    return new_object
  end
  
  def update_object(params)
    self.start_datetime = params[:start_datetime]
    self.end_datetime = params[:end_datetime]
    self.title = params[:title]
    self.calendar_id = params[:calendar_id]
    self.customer_id = params[:customer_id]
    self.save 
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
end
