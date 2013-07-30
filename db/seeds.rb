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

admin = User.create_main_user(   :email => "admin@gmail.com" ,:password => "willy1234", :password_confirmation => "willy1234") 

admin.set_as_main_user

def make_date(*args)
  now = DateTime.now  
  
  d = ( args[0] || 0 )
  h = (args[1]  || 0)  
  m = (args[2] || 0)  
  s = (args[3] || 0)  
  
  return ( now  + d.days + h.hours + m.minutes + s.seconds   ) .new_offset( Rational(0,24) ) 
end


booking_list = [{
    "calendar_id"     => "C1",
    "title"  => "Vacation",
    "start_datetime"   =>   make_date(-20, 10),
    "end_datetime"     => make_date(-10, 15) 
},{
    "calendar_id"     => "C2",
    "title"  => "Lunch with Matt",
    "start_datetime"   =>   make_date(0, 11, 30),
    "end_datetime"     => make_date(0, 13) 
},{
    "calendar_id"     => "C3",
    "title"  => "Project due",
    "start_datetime"   =>   make_date(0, 15),
    "end_datetime"     => make_date(0, 15) 
},{
    "calendar_id"     => "C1",
    "title"  => "Sarah's birthday",
    "start_datetime"   =>   make_date(0),
    "end_datetime"     => make_date(0)
},{
    "calendar_id"     => "C2",
    "title"  => "A long one...",
    "start_datetime"   =>   make_date(-12),
    "end_datetime"     => make_date(10, 0, 0, -1) 
},{
    "calendar_id"     => "C3",
    "title"  => "School holiday",
    "start_datetime"   =>   make_date(5),
    "end_datetime"     => make_date(5) 
},{
    "calendar_id"     => "C1",
    "title"  => "Haircut",
    "start_datetime"   =>   make_date(0, 9),
    "end_datetime"     => make_date(0, 9, 0, 30) 
},{
    "calendar_id"     => "C3",
    "title"  => "An old event",
    "start_datetime"   =>   make_date(-30),
    "end_datetime"     => make_date(-28) 
},{
    "calendar_id"     => "C2",
    "title"  => "Board meeting",
    "start_datetime"   =>   make_date(-2, 13),
    "end_datetime"     => make_date(-2, 18),
    "location"   => "ABC Inc.",
    "reminder"   => "60",
    "created_by" => "Brian"
},{
    "calendar_id"     => "C3",
    "title"  => "Jenny's final exams",
    "start_datetime"   =>   make_date(-2),
    "end_datetime"     => make_date(3, 0, 0, -1) 
},{
    "calendar_id"     => "C1",
    "title"  => "Movie night",
    "start_datetime"   =>   make_date(2, 19),
    "end_datetime"     => make_date(2, 23) 
},{
    "calendar_id"     => "C4",
    "title"  => "Gina's basketball tournament",
    "start_datetime"   =>   make_date(8, 8),
    "end_datetime"     => make_date(10, 17) 
},{
    "calendar_id"     => "C4",
    "title"  => "Toby's soccer game",
    "start_datetime"   =>   make_date(5, 10),
    "end_datetime"     => make_date(5, 12) 
}]

booking_list.each do |booking|
  Booking.create booking 
end