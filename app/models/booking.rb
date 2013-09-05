class Booking < ActiveRecord::Base
  has_many :incomes, :as => :income_source 
  
  belongs_to :calendar 
  belongs_to :customer
  belongs_to :price 
  
  def facility
    calendar 
  end
  
  attr_accessible :start_datetime, :number_of_hours,
          :title, :calendar_id , :customer_id, :price_id 
          
  validates_presence_of :start_datetime, :number_of_hours ,  :customer_id , :calendar_id 
  
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
    self.where(:is_deleted => false ) 
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
  
  
  def title
    "[#{self.booking_code}] #{self.customer.name}"
  end
  
  
  
   
  
  def self.create_object( params ) 
    new_object = self.new 
    new_object.start_datetime = params[:start_datetime]
    new_object.number_of_hours = params[:number_of_hours]
    # new_object.title = params[:title]
    new_object.calendar_id = params[:calendar_id]
    new_object.customer_id = params[:customer_id]
    new_object.discount = BigDecimal( params[:discount] || 0) 
    
    if new_object.save 
      new_object.update_end_datetime 
      new_object.update_price  
      new_object.generate_booking_code
    end
    return new_object
  end
  
  def update_object(params)
    if self.is_confirmed? or self.is_paid? 
      self.update_post_confirm(params)
      return self
    end
    self.start_datetime = params[:start_datetime]
    self.number_of_hours = params[:number_of_hours]
    # self.title = params[:title]
    self.calendar_id = params[:calendar_id]
    self.customer_id = params[:customer_id]
    self.discount = BigDecimal( params[:discount] || 0) 
   
    if self.save 
      self.update_end_datetime
    end
    return self
  end
  
  def update_post_confirm(params)
    is_number_of_hours_changed = false 
    is_discount_changed = false 
    if self.number_of_hours != params[:number_of_hours].to_i
      is_number_of_hours_changed = true 
    end
    
    if self.discount != BigDecimal( params[:discount])
      is_discount_changed = true 
    end
    
    
    self.start_datetime = params[:start_datetime]
    self.number_of_hours = params[:number_of_hours]
    # self.title = params[:title]
    self.calendar_id = params[:calendar_id]
    self.customer_id = params[:customer_id]
    self.discount = BigDecimal( params[:discount] || 0) 
    
    if self.save 
      if is_discount_changed or is_number_of_hours_changed
        self.update_income 
      end
    end
    
  end
  
  def downpayment_income 
    self.incomes.where(:case => INCOME_CASE[:downpayment]).first 
  end
  
  def remaining_income
    self.incomes.where(:case => INCOME_CASE[:remaining_payment]).first 
  end
  
  def update_income
    if self.is_confirmed?  
      downpayment = self.downpayment_income 
      downpayment.amount  = self.downpayment_amount
      downpayment.save 
    end
    
    
    if self.is_paid? 
      remaining = self.remaining_income 
      remaining.amount = self.remaining_amount
      remaining.save
    end
    
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
  
  def discounted_total_price 
    (( 100 - self.discount)/100.to_f) * self.total_price
  end
  
  def downpayment_amount 
     self.discounted_total_price * (self.calendar.downpayment_percentage/100.to_f)
  end
  
  def remaining_amount 
    self.discounted_total_price - self.downpayment_amount 
  end
  
  
  def confirm
    return if self.is_confirmed? 
    
    self.is_confirmed = true 
    self.confirmed_datetime = DateTime.now 
    self.save 
    
    
    self.generate_code 
    
    Income.create :income_source_type => self.class.to_s , 
                  :income_source_id => self.id ,
                  :amount => self.downpayment_amount ,
                  :case => INCOME_CASE[:downpayment],
                  :transaction_datetime => self.confirmed_datetime,
                  :code => self.confirmation_code 
    
  
  end
  
  def pay
    return if self.is_paid? 
    return if self.is_deleted? 
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "Harus konfirmasi terlebih dahulu")
      return self 
    end
    
    self.is_paid = true 
    self.paid_datetime  = DateTime.now 
    self.save 
    
    
    Income.create :income_source_type => self.class.to_s , 
                  :income_source_id => self.id ,
                  :amount => self.remaining_amount,
                  :case => INCOME_CASE[:remaining_payment],
                  :transaction_datetime =>  self.paid_datetime,
                  :code => self.remaining_payment_code
    
  end
  
  def update_actual_start_datetime( start_datetime )
    if start_datetime.nil?
      self.errors.add(:actual_start_datetime, "Jam mulai harus di isi")
      return self 
    end
    
    self.actual_start_datetime = start_datetime
    self.save 
  end
  
  def update_actual_end_datetime( end_datetime )
    
    if self.actual_start_datetime.nil? 
      self.errors.add(:actual_end_datetime, "Jam mulai harus di isi")
      return self 
    end
    
    
    if end_datetime.nil?
      self.errors.add(:actual_end_datetime, "Jam selesai harus di isi")
      return self 
    end
    
    if end_datetime < self.actual_start_datetime
      self.errors.add(:actual_end_datetime, "Tidak boleh lebih awal dari jam mulai")
      return self 
    end
    
    self.actual_end_datetime = end_datetime
    self.save 
  end
  
  def delete_object
    if self.is_confirmed? or self.is_paid? 
      self.incomes.each {|x| x.destroy }
      self.is_deleted = true 
      self.save 
    else
      self.destroy 
    end
  end
  
  def generate_booking_code
    unique = false 
    proposed_booking_code = ''
    
    while not unique  do
      proposed_booking_code =  UUIDTools::UUID.timestamp_create.to_s[0..4]

      start_datetime = Date.today.at_beginning_of_month.to_datetime
      end_datetime = Date.today.next_month.at_beginning_of_month.to_datetime

      counter = Booking.where{
        (booking_code.eq proposed_booking_code) & 
        (created_at.gte start_datetime)  & 
        (created_at.lt end_datetime ) 
      }.count
      
      unique = true if counter == 0 
    end
    
    self.booking_code = proposed_booking_code
    self.save 
  end
  
  def generate_code
    # get the total number of sales order created in that month 
    
    # total_sales_order = SalesOrder.where()
    start_datetime = Date.today.at_beginning_of_month.to_datetime
    end_datetime = Date.today.next_month.at_beginning_of_month.to_datetime
  
 
    counter = self.class.where{
       (created_at >= start_datetime)  & 
       (created_at < end_datetime ) & 
       (is_confirmed.eq true )
     }.count 
    
  
    string = "BOOK" + "/" + 
              self.created_at.year.to_s + '/' + 
              self.created_at.month.to_s + '/' + 
              counter.to_s
              
    self.code =  string 
    self.save 
  end
  
  def confirmation_code
    return "" if not self.is_confirmed? 
    
    "#{self.code}-CONFIRM"
  end
  
  def remaining_payment_code
    return "" if not self.is_paid?
    
    "#{self.code}-PAY"
  end
end

=begin
Booking.where
=end
