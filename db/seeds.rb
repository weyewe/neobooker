

role = {
  :system => {
    :administrator => true
  }
}

Role.create!(
:name        => ROLE_NAME[:admin],
:title       => 'Administrator',
:description => 'Role for administrator',
:the_role    => role.to_json
)


current_office = Office.create_object :name => "OFfice1", :description => "balblalbalba", :code => "XXX"

Account.setup_business
Account.all.each {|x| x.office_id = current_office.id; x.save ; }

data_entry_role = {
  :passwords => {
    :update => true 
  },
  :calendars => {
    :search => true,
    :index => true ,
    # there are 2: update is hack for extensible.. 
    # update details  => authorization to update discount, calendar name, etc
    :update => true,
    :update_details => false 
  },
  :customers => {
    :new => true,
    :create => true, 
    :edit => true, 
    :update => true ,
    :destroy => true  ,
    :index => true ,
    :search => true 
  },
  :bookings => {
    :new => true,
    :create => true, 
    :edit => true, 
    :update => true ,
    :destroy => true ,
    :confirm => true,
    :pay => true, 
    :index => true ,
    :search => true,
    :update_start_datetime => true, 
    :update_end_datetime => true 
  } ,
  :events => {
    :index => true 
  }
}

data_entry_role = Role.create!(
  :name        => ROLE_NAME[:data_entry],
  :title       => 'Data Entry',
  :description => 'Role for data entry',
  :the_role    => data_entry_role.to_json
)




manager_role = {
  :passwords => {
    :update => true 
  },
  :calendars => {
    :search => true,
    :index => true,
    :update => true ,
    :update_details => false 
  },
  :customers => {
    :new => true,
    :create => true, 
    :edit => true, 
    :update => true ,
    :destroy => true  ,
    :index => true,
    :search => true 
  },
  :bookings => {
    :new => true,
    :create => true, 
    :edit => true, 
    :update => true ,
    :destroy => true ,
    :confirm => true,
    :pay => true, 
    :index => true ,
    :post_confirm_destroy => true,
    :post_confirm_update => true, 
    :add_discount => true ,
    :search => true ,
    :update_start_datetime => true, 
    :update_end_datetime => true
  },
  :events => {
    :index => true
  }
}

 



manager_role = Role.create!(
  :name => ROLE_NAME[:manager],
  :title => "Manager",
  :description => "Role for manager: post confirm update",
  :the_role => manager_role.to_json 
)


admin = current_office.users.create_main_user(  :name => "Admin", :email => "admin@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 

admin.set_as_main_user

manager = current_office.users.create_object(:name => "Manager", :email => "manager@gmail.com", 
              :password => 'willy1234', 
              :password_confirmation => 'willy1234',
              :role_id => manager_role.id ) 
              
manager.password = 'willy1234'
manager.password_confirmation = 'willy1234'
manager.save 

data_entry = current_office.users.create_object(:name => "Data Entry", :email => "data_entry@gmail.com", 
              :password => 'willy1234', 
              :password_confirmation => 'willy1234',
              :role_id => data_entry_role.id )
              
data_entry.password = 'willy1234'
data_entry.password_confirmation = 'willy1234'
data_entry.save


if Rails.env.development?
  
  customer_array = ["WXU", "DOA IBU", "KCFC Vs SKT", "KCR", "DEDY ARPAN", "DANU", "PERSIJAP", "CIBI", "F.SEVEN ", 
    "ACE Alam sutera", "BTN", "RICKY", "KCC", "BANDARA FC", "WIK FC", "BUJANG", "IGI", "SOPIAN/LINGNET", 
    "IPS-3", "FRANDI", "LANUS FC", "YOLANDI", "BULAC FC", "DARUSALAM AN-NUR", 
    "BAGAS", "FAUZI Pamindo", "EDO", "SOFYAN", "MULYA", "SMK 5", "YOGI", "MEGA KARYA", "STEVEN 2", 
    "ODI DIKUN", "ALDI I", "EMMANUEL RIO", "CHEVY FUTSAL SERPONG", "MDS MATAHARI", "WILLY", 
    "ANDREAS", "DEDE", "DIMAS", "NARDO", "ARIF", "BUDI", "YANTO", "WASLI", "GRIYA HIJAU", "INFORMA", 
    "BINUS", "BONAR FC", "IRGI", "SEHATI FC", "ONE LOVE", "PORTAL", "ROMY", "FERDI", "CiKE'", "ARIS", 
    "FRONTLINER", "GAPURA FC", "BOWO", "ADENA", "BOUGENVILLE", "EGI", "RENDI", "COBRA FC", "DANFUL FC", 
    "UMAY", "SUKMA (KATEL)", "KARPET", "GALIH RINADI", "IDRIS", "ABRAHAM", "WARSU", "ALKA", "DAFA", "NAMEL", 
    "JAYA BOARD", "NYENDER FC", "ALSUT FC ", "MARGA MOTOR", "GENARO", "DICKY", "ABI", "MICHAEL", "KARANG TARUNA", 
    "DUCKING PSS", "TIO", "PSM", "ALDI ALPA", "MJM", "TKJ", "INDRA", "JOSHUA", "PT.HMT", "SKS", "MEJIKU FC", 
    "JELUPANG", "TKP"]
    
  customer_array.each do |x|
    customer = current_office.customers.create_object({
      :name => x
    })
  end
  
  customer_array = current_office.customers.all
  
  



  @objects = [{
       "cal_id"    => "C1",
       "cal_title" => "Home",
       "cal_color" => 2
   },{
       "cal_id"    => "C2",
       "cal_title" => "Work",
       "cal_color" => 22
   },{
       "cal_id"    => "C3",
       "cal_title" => "School",
       "cal_color" => 7
   },{
       "cal_id"    => "C4",
       "cal_title" => "Sports",
       "cal_color" => 26
   }]

  c1 = current_office.calendars.create_object({
    :title => "Futsal 1",
    :color => 2 ,
    :amount => '200000',
    :downpayment_percentage => '20'
  })

  c2 = current_office.calendars.create_object({
    :title => "Futsal 2",
    :color => 22  ,
    :amount => '200000',
    :downpayment_percentage => '20'
  })
  c3 = current_office.calendars.create_object({
    :title => "Futsal 3",
    :color => 7  ,
    :amount => '200000',
    :downpayment_percentage => '20'
  })
  c4 = current_office.calendars.create_object({
    :title => "Futsal 4",
    :color => 26  ,
    :amount => '200000',
    :downpayment_percentage => '20'
  })




  def make_date(*args)
    now = DateTime.now  

    d = ( args[0] || 0 )
    h = (args[1]  || 0)  
    m = (args[2] || 0)  
    s = (args[3] || 0)  


    target_date = ( now  + d.days + h.hours + m.minutes + s.seconds   ) .new_offset( Rational(0,24) ) 

    adjusted_date = DateTime.new( target_date.year, target_date.month, target_date.day, 
                                  h, 0 , 0 
              ) .new_offset( Rational(0,24) ) 

    # return ( now  + d.days + h.hours + m.minutes + s.seconds   ) .new_offset( Rational(0,24) ) 
    return adjusted_date 
  end

  # objective is to create bookings, scattered since 1 month ago
  # end result: demonstrate the reporting (cash to be stored, daily)

  calendar_array = [c1,c2,c3,c4]


  
  
  (-30..0).each do |day|
    calendar_array.each do |calendar|
      customer = customer_array[ rand(0..customer_array.length-1)]
  
      starting_hour = rand( (9-7)..(18-7))  # stored as UTC.. we need to adjust with the conversion to Jakarta time
      duration = rand(1..4)
  
      start_datetime = make_date( day, starting_hour)
  
      booking_params = {
        :calendar_id => calendar.id , 
        :title => "#{customer.name} booking",
        :start_datetime => start_datetime , 
        :number_of_hours => duration ,
        :customer_id => customer.id ,
        :is_downpayment_imposed => true 
      }
  
      booking = current_office.bookings.create_object booking_params 
      if booking.errors.size != 0 
        booking.errors.each do |msg|
          puts msg 
        end
      end
  
      booking.confirm( booking.created_at + 30.minutes)
      booking.pay( booking.start_datetime + 2.hours)
    end
  end
  


end

 