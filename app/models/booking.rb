class Booking < ActiveRecord::Base
  has_many :incomes, :as => :income_source 
  
  belongs_to :calendar 
  belongs_to :customer
  belongs_to :price 
  
  has_many :price_details 
  has_one :salvage_booking
  
  def facility
    calendar 
  end
  
  attr_accessible :start_datetime, :number_of_hours,
          :title, :calendar_id , :customer_id, :price_id 
          
  validates_presence_of :start_datetime, :number_of_hours ,  
                        :customer_id , :calendar_id  
  
  after_destroy :destroy_price_details
  
  validate :valid_customer_id
  validate :valid_calendar_id
  validate :valid_number_of_hours
  
  validate :no_double_booking
  validate :limit_booking_from_8_to_12
  
  validate :no_minutes_in_start_datetime 
  
  def no_minutes_in_start_datetime
    return if start_datetime.nil? 
    local_datetime = start_datetime.in_time_zone("Jakarta") 
    
    if local_datetime.to_datetime.minute !=  0 
      self.errors.add(:start_datetime, "Waktu mulai booking harus bulat: tidak boleh ada menit.")
      return self 
    end
  end
  
  
  def limit_booking_from_8_to_12
    return if start_datetime.nil? 
    return if number_of_hours.nil? or number_of_hours < 1 
    
    local_datetime = start_datetime.in_time_zone("Jakarta") 
    finish_datetime = local_datetime + number_of_hours.hours 
    
    # earlier than 8am 
    if local_datetime.hour < 8 
      self.errors.add(:start_datetime, "Tidak boleh lebih awal dari jam 8 pagi")
      return self 
    end
    
    # different day
    puts "finish_datetime: #{finish_datetime}"
    puts "local_datetime: #{local_datetime}"
    result = finish_datetime - local_datetime
    puts "result.to_i : #{result.to_i}"
    
    is_at_the_same_day = Time.at(finish_datetime).to_date === Time.at(local_datetime).to_date
    
    
    if not is_at_the_same_day
      self.errors.add(:number_of_hours, "Booking hanya dari jam 8 sampai 12 malam")
      return self
    end
    
  end
  
  def no_double_booking
    return if calendar_id.nil? 
    return if start_datetime.nil? 
    return if number_of_hours.nil? or number_of_hours < 1 
    
    selected_calendar_id = calendar_id 
    current_id = self.id 
    current_start_datetime = start_datetime
    current_end_datetime = start_datetime + number_of_hours.hours 
    
    total_other_bookings = 0 
    if self.persisted?
      total_other_bookings = Booking.where{
        ( calendar_id.eq selected_calendar_id) & 
        ( id.not_eq current_id ) & 
        (
          # current_start_datetime intersection 
          ( 
            (start_datetime.lte current_start_datetime)  & 
            (end_datetime.gte current_start_datetime)
          )  | 
          # current_end_datetime intersection 
          (
            (end_datetime.gte  current_end_datetime) & 
            (start_datetime.lte current_end_datetime )
          ) | 
          # currently_booking is subset of other booking 
          (
            (start_datetime.lte current_start_datetime) &
            (end_datetime.gte current_end_datetime )
          )
        )
      }.count 
    else
      total_other_bookings = Booking.where{
        ( calendar_id.eq selected_calendar_id) & 
        (
          # current_start_datetime intersection 
          ( 
            (start_datetime.lte current_start_datetime)  & 
            (end_datetime.gte current_start_datetime)
          )  | 
          # current_end_datetime intersection 
          (
            (end_datetime.gte  current_end_datetime) & 
            (start_datetime.lte current_end_datetime )
          ) | 
          # currently_booking is subset of other booking 
          (
            (start_datetime.lte current_start_datetime) &
            (end_datetime.gte current_end_datetime )
          )
        )
      }.count
      
    end
    
    if total_other_bookings > 0 
      self.errors.add(:generic_errors, " Sudah ada #{total_other_bookings} booking parallel")
      return 
    end
  end
  
  def destroy_price_details
    self.price_details.each {|x| x.destroy }
  end
  
=begin
Scenario
In January,base  price == 400,000 
Now, (september), base price == 500,000 

Of course the January price has been expired. However, there is wrong data entry made in January. 
It has to be fixed: add number_of_hours. 

Solution: get the PriceRule on that is active on the creation time 
=end

  def price_rules 
    # puts "The start datetime: #{start_datetime}"
    
    local_datetime = start_datetime.in_time_zone("Jakarta") 
    # puts "Jakarta_datetime: #{local_datetime} "
    result_array = []
    current_calendar_id = self.calendar_id
    
    # how can we get the available price rules?
    # 1. get all 
    
    # for each booked hour, get the associated price rule 
    (1..number_of_hours).each do |x|
      datetime = local_datetime + (x-1).hours 
      actual_booking_datetime = start_datetime + (x-1).hours 
      
      book_hour_start = datetime.hour
      booking_creation_datetime = self.created_at 
      
   
      # check if there is holiday on that day
      holiday_price_rule = PriceRule.where(
        :is_holiday => true, 
        :is_active => true ,
        :holiday_date => ( actual_booking_datetime.beginning_of_day - 7.hours)..(actual_booking_datetime.end_of_day - 7.hours)
      ).order(" id DESC").first
      
      
      if not holiday_price_rule.nil?
        result_array << holiday_price_rule.id
      else
        
        price_rules = PriceRule.where{
          #  to ensure that we are using the old price at the time of creation
          (
            calendar_id.eq current_calendar_id
          ) & 


          (
            # is still active, and created before the booking creation 
            (
              ( is_active.eq true) & 
              (created_at.lte booking_creation_datetime)
            ) | 
            # is not active, and created before the booking creation
            # and deactivated after the booking creation => 
            # Hence, the rule is still in place
            (
              ( is_active.eq false) & 
              ( created_at.lte booking_creation_datetime) & 
              ( deactivated_at.gt booking_creation_datetime)
            )
          )  & 

          # 0 - 23 
          (
            ( hour_start.lte datetime.hour ) & 
            ( hour_end.gte datetime.hour )
          )
        }.order("id ASC, rule_case DESC")  # rule_case 2 == holiday, 1== specific, rule case 0= catch_all

        # puts "Total price rule: #{price_rule.count}"

        final_price_rule = []


        price_rules.each do |x|
          if x.is_sunday? and datetime.sunday?
            final_price_rule <<  x 
          elsif x.is_monday? and  datetime.monday?
            final_price_rule <<  x 
          elsif x.is_tuesday? and  datetime.tuesday?
            final_price_rule <<  x 
          elsif x.is_wednesday? and  datetime.wednesday?
            final_price_rule <<  x 
          elsif x.is_thursday? and  datetime.thursday?
            final_price_rule <<  x 
          elsif x.is_friday? and  datetime.friday?
            final_price_rule <<  x 
          elsif x.is_saturday? and  datetime.saturday? 
            final_price_rule <<  x 
          end
        end


        price_rule = final_price_rule.sort_by {|x| x.id }.last

        result_array << price_rule.id

        # corner case:
        # rule 1 : 1300-1300
        # rule 2 : 1300-1400 
        # booking time: 13.30 .. which rule will be selected? 
        # we have the ordering by id, ASC
        # in this case: rule2 is created later.. rule2 will be selected. 

        # corner case
        # rule1 : 2300-2300 
        # it means it will only affect the time from 2300-2400 


        
      end
      

    end
    
    return result_array
  end
  
  def create_price_details  
    destroy_price_details
    self.reload   
    
    # example: booking from 16:00 to 18:00 .. 16 - 17 == 300k , 17-18 == 500k 
    result_array = self.price_rules 
    uniq_result_array = result_array.uniq 
    
    final_result_array = [] 
    
    # wtf logic is happening over here?
    # simple, for each price rule, we want to get the number of hours
    # price rules are returned as price rule per hour 
    uniq_result_array.each do |x|
      counter = 0 
      result_array.each do |x2|
        counter += 1 if x2 == x  
      end
      
      final_result_array << [x, counter]
    end
    
    final_result_array.each do |pair|
      PriceDetail.create_object(
        :booking_id => self.id,
        :price_rule_id => pair.first,
        :number_of_hours => pair.last  
      )
    end
    
    self.amount = self.price_details.sum("amount")
    self.save  
  end
  
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
    # self.price_id = self.calendar.active_price.id  
    # self.save  
    self.create_price_details
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
    
    new_object.is_downpayment_imposed = params[:is_downpayment_imposed]   
    
      
   
    new_object.valid? 
    
    # puts "The errors: #{new_object.errors.size}"
    
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
    
    is_start_datetime_changed = false 
    is_number_of_hours_changed = false
    is_calendar_id_changed = false 
    
    if start_datetime != params[:start_datetime]
      is_start_datetime_changed = true 
    end
    
    if number_of_hours != params[:number_of_hours]
      is_number_of_hours_changed = true 
    end
    
    if is_downpayment_imposed != params[:is_downpayment_imposed]
      is_downpayment_imposed_changed = true 
    end
    
    if calendar_id != params[:calendar_id]
      is_calendar_id_changed = true 
    end
    
     
    
    self.start_datetime = params[:start_datetime]
    self.number_of_hours = params[:number_of_hours]
    # self.title = params[:title]
    self.calendar_id = params[:calendar_id]
    self.customer_id = params[:customer_id]
    self.discount = BigDecimal( params[:discount] || 0) 
    self.is_downpayment_imposed =  params[:is_downpayment_imposed]
   
    if self.save 
      self.update_end_datetime
      
      if is_start_datetime_changed or is_number_of_hours_changed or is_calendar_id_changed
        self.create_price_details
      end
    end
    return self
  end
  
  def update_post_confirm(params)
    
    if self.is_confirmed? and self.is_downpayment_imposed != params[:is_downpayment_imposed]
      self.errors.add(:is_downpayment_imposed, "Tidak boleh mengubah kondisi downpayment setelah konfirmasi")
      return self 
    end
    
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
        self.create_price_details 
      end
    end
    
  end
  
  def downpayment_income 
    self.incomes.where(:case => INCOME_CASE[:downpayment]).first 
  end
  
  def remaining_income
    self.incomes.where(:case => INCOME_CASE[:remaining_payment]).first 
  end
  
  def remaining_amount 
    self.discounted_total_price - self.downpayment_amount 
  end
  
  def create_booking_income
    Income.create_booking_confirmation_income(
      :income_source_type => self.class.to_s , 
      :income_source_id => self.id ,                       
      :amount => self.downpayment_amount ,                 
      :case => INCOME_CASE[:downpayment],                  
      :transaction_datetime => self.confirmed_datetime,    
      :code => self.confirmation_code   
    )
  end
  
  def create_salvage_downpayment_amount_income
    dp_income = self.downpayment_income 
    
    if dp_income.nil?
      if self.downpayment_amount != BigDecimal('0')
        dp_income = self.create_booking_income 
      else
        return 
      end
    end
    
    dp_income.salvage_booking_income 
  end
  
  def create_remaining_income
    Income.create_remaining_payment_income(
      :income_source_type => self.class.to_s , 
      :income_source_id => self.id ,
      :amount => self.remaining_amount,
      :case => INCOME_CASE[:remaining_payment],
      :transaction_datetime =>  self.paid_datetime,
      :code => self.remaining_payment_code
    )        
  end
  
  def update_downpayment_income 
    dp_income = self.downpayment_income 
    
    if dp_income.nil?
      if new_amount == BigDecimal('0')
        return 
      else
        self.create_booking_income
      end
    else
      
      if amount == BigDecimal('0')
        dp_income.delete_object
      else
        dp_income.update_amount( self.downpayment_amount )
      end
      
    end
    
  end
  
  def update_remaining_income 
    rm_income = self.remaining_income 
    
    if rm_income.nil?
      if new_amount == BigDecimal('0')
        return 
      else
        self.create_remaining_income
      end
    else
      
      if amount == BigDecimal('0')
        rm_income.delete_object
      else
        rm_income.update_amount( self.remaining_amount )
      end
      
    end
    
  end
  
  
  
  def update_income
    if self.is_confirmed?  
      self.update_downpayment_income  
    end
    
    
    if self.is_paid? 
      # self.update_remaining_income 
      self.update_remaining_income
      # remaining_income = self.remaining_income 
      # remaining_income.amount = self.remaining_amount
      # remaining_income.save
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
    # self.number_of_hours * self.price.amount 
    self.amount 
  end
  
  def discounted_total_price 
    (( 100 - self.discount)/100.to_f) * self.total_price
  end
  
  def downpayment_amount 
    if self.is_downpayment_imposed?
      return self.discounted_total_price * (self.calendar.downpayment_percentage/100.to_f)
    else
      return BigDecimal('0')
    end
  end
  
  def confirm
    return if self.is_confirmed? 
    
    self.is_confirmed = true 
    self.confirmed_datetime = DateTime.now 
    self.save 
    
    
    self.generate_code 
    
    if self.downpayment_amount != BigDecimal('0')
      self.create_booking_income  
    end
    
     
  end
  
  
  
  def pay
    return if self.is_paid? 
    return if self.is_deleted? 
    if not self.is_confirmed?
      self.errors.add(:generic_errors, "Harus konfirmasi terlebih dahulu")
      return self 
    end
    
    if self.is_salvaged? 
      self.errors.add(:generic_errors, "Sudah hangus")
      return self
    end
    
    self.is_paid = true 
    self.paid_datetime  = DateTime.now 
    self.save 
    
    
    if self.remaining_amount != BigDecimal("0")
      self.create_remaining_income
    end
    
    # Income.create :income_source_type => self.class.to_s , 
    #               :income_source_id => self.id ,
    #               :amount => self.remaining_amount,
    #               :case => INCOME_CASE[:remaining_payment],
    #               :transaction_datetime =>  self.paid_datetime,
    #               :code => self.remaining_payment_code
    
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
  
  
  def is_salvaged?
    not self.salvage_booking.nil?
  end
  
  def execute_salvage
    if self.is_salvaged?
      self.errors.add(:generic_errors, "Booking sudah hangus. ")
      return self 
    end
    
    if self.is_deleted?
      self.errors.add(:generic_errors,"Sudah di hapus")
      return self 
    end
    
    if self.is_confirmed? and not self.is_paid?
      SalvageBooking.create_object :booking_id => self.id, :salvaged_datetime => DateTime.now  
    else
      self.errors.add(:generic_errors, "Booking harus sudah dikonfirmasi dan belum dibayar sisanya")
      return self 
    end
  end
  
  def delete_object
    if self.is_confirmed? or self.is_paid?  or self.is_salvaged? 
      self.incomes.each {|x| x.delete_object }
      self.is_deleted = true 
      self.save 
      
      self.salvaged_booking.delete_object 
      
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
