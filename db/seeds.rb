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



data_entry_role = {
  :customers => {
    :new => true,
    :create => true, 
    :edit => true, 
    :update_customer => true ,
    :delete_customer => true  
  },
  :bookings => {
    :new => true,
    :create => true, 
    :edit => true, 
    :update_booking => true ,
    :delete_booking => true ,
    :confirm_booking => true 
  }
}


data_entry_role = Role.create!(
:name        => ROLE_NAME[:data_entry],
:title       => 'Data Entry',
:description => 'Role for data entry',
:the_role    => data_entry_role.to_json
)



admin = User.create_main_user(   :email => "admin@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 

admin.set_as_main_user

customer = Customer.create_object({
  :name => "Andy"
})

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
 
c1 = Calendar.create_object({
  :title => "Home",
  :color => 2 
})

c2 = Calendar.create_object({
  :title => "Work",
  :color => 22 
})
c3 = Calendar.create_object({
  :title => "School",
  :color => 7 
})
c4 = Calendar.create_object({
  :title => "Sports",
  :color => 26 
})
 

def make_date(*args)
  now = DateTime.now  
  
  d = ( args[0] || 0 )
  h = (args[1]  || 0)  
  m = (args[2] || 0)  
  s = (args[3] || 0)  
  
  return ( now  + d.days + h.hours + m.minutes + s.seconds   ) .new_offset( Rational(0,24) ) 
end


booking_list = [{
    "calendar_id"     => c1.id ,
    "title"  => "Vacation",
    "start_datetime"   =>   make_date(-20, 10),
    "end_datetime"     => make_date(-10, 15) 
},{
    "calendar_id"     => c2.id ,
    "title"  => "Lunch with Matt",
    "start_datetime"   =>   make_date(0, 11, 30),
    "end_datetime"     => make_date(0, 13) 
},{
    "calendar_id"     => c3.id ,
    "title"  => "Project due",
    "start_datetime"   =>   make_date(0, 15),
    "end_datetime"     => make_date(0, 15) 
},{
    "calendar_id"     => c1.id ,
    "title"  => "Sarah's birthday",
    "start_datetime"   =>   make_date(0),
    "end_datetime"     => make_date(0)
},{
    "calendar_id"     => c2.id ,
    "title"  => "A long one...",
    "start_datetime"   =>   make_date(-12),
    "end_datetime"     => make_date(10, 0, 0, -1) 
},{
    "calendar_id"     => c3.id ,
    "title"  => "School holiday",
    "start_datetime"   =>   make_date(5),
    "end_datetime"     => make_date(5) 
},{
    "calendar_id"     => c1.id ,
    "title"  => "Haircut",
    "start_datetime"   =>   make_date(0, 9),
    "end_datetime"     => make_date(0, 9, 0, 30) 
},{
    "calendar_id"     => c3.id ,
    "title"  => "An old event",
    "start_datetime"   =>   make_date(-30),
    "end_datetime"     => make_date(-28) 
},{
    "calendar_id"     => c2.id ,
    "title"  => "Board meeting",
    "start_datetime"   =>   make_date(-2, 13),
    "end_datetime"     => make_date(-2, 18),
    "location"   => "ABC Inc.",
    "reminder"   => "60",
    "created_by" => "Brian"
},{
    "calendar_id"     => c3.id ,
    "title"  => "Jenny's final exams",
    "start_datetime"   =>   make_date(-2),
    "end_datetime"     => make_date(3, 0, 0, -1) 
},{
    "calendar_id"     =>c1.id ,
    "title"  => "Movie night",
    "start_datetime"   =>   make_date(2, 19),
    "end_datetime"     => make_date(2, 23) 
},{
    "calendar_id"     => c4.id,
    "title"  => "Gina's basketball tournament",
    "start_datetime"   =>   make_date(8, 8),
    "end_datetime"     => make_date(10, 17) 
},{
    "calendar_id"     => c4.id,
    "title"  => "Toby's soccer game",
    "start_datetime"   =>   make_date(5, 10),
    "end_datetime"     => make_date(5, 12) 
}]

booking_list.each do |booking|
  hash = {}
  booking.each do |key,value|
    hash[key.to_sym] = value 
  end
  puts hash 
  hash[:customer_id] = customer.id
  Booking.create_object hash 
end