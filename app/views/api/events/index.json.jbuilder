json.success true 
json.total @total
json.events @objects do |object|
	json.id 								object.id 
                                         
	json.start_datetime 		format_datetime(object.start_datetime)  
	json.end_datetime 			format_datetime(object.end_datetime)    

	json.title 							object.title
	json.calendar_id 				object.calendar_id
	json.customer_name 				object.customer.name


	
end
