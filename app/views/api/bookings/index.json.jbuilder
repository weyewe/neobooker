json.success true 
json.total @total
json.bookings @objects do |object|
	json.id 								object.id 

	
	json.booking_datetime 			format_datetime_friendly(object.created_at)    

	json.title 							object.title
	json.calendar_id 				object.calendar_id
	json.customer_name 				object.customer.name
	json.facility_title 			 "Muka Gila" #	object.calendar.title
	
	#// bokoing details 
	json.start_datetime 		format_datetime_friendly(object.start_datetime)  
	json.end_datetime 			format_datetime_friendly(object.end_datetime)
	
	
	# // Confirmation Status
	json.is_confirmed 				object.is_confirmed 
	json.downpayment_amount 				object.downpayment_amount
	
	
	 #// Actual
	json.actual_start_datetime 		format_datetime_friendly(object.actual_start_datetime)  
	json.actual_end_datetime 			format_datetime_friendly(object.actual_end_datetime)
	
	
	
	
	
	 #// Payment Status
	json.is_paid 				object.is_paid 
	json.remaining_amount 				object.remaining_amount


	
end
