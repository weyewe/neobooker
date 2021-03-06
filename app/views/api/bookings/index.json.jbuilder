json.success true 
json.total @total
json.bookings @objects do |object|
	json.id 								object.id 

	
	json.booking_datetime 			format_datetime_friendly(object.created_at)    

	json.title 							object.title
	json.calendar_id 				object.calendar_id
	json.customer_id 				object.customer_id 
	json.customer_name 				object.customer.name
	json.facility_title 			object.calendar.title
	
	#// bokoing details 
	json.start_datetime 		format_datetime_friendly(object.start_datetime)  
	json.end_datetime 			format_datetime_friendly(object.end_datetime)
	json.number_of_hours     object.number_of_hours 
	
	json.total_price 	object.total_price.to_s 
	
	json.downpayment_amount object.downpayment_amount.to_s 
	json.remaining_amount object.remaining_amount.to_s 
	
	
	# // Confirmation Status
	json.is_confirmed 				object.is_confirmed 
#	// json.downpayment_amount 				object.downpayment_amount
	
	
	 #// Actual
	json.actual_start_datetime 		format_datetime_friendly(object.actual_start_datetime)  
	json.actual_end_datetime 			format_datetime_friendly(object.actual_end_datetime)
	json.discount 			object.discount 
	json.is_salvaged object.is_salvaged
	
	json.booking_code object.booking_code 
	json.confirmation_code object.confirmation_code
	json.remaining_payment_code object.remaining_payment_code 
	
	json.is_downpayment_imposed object.is_downpayment_imposed
	
	
	
	
	
	
	 #// Payment Status
	json.is_paid 				object.is_paid 
#	json.remaining_amount 				object.remaining_amount


	
end
