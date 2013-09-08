json.success true 
json.total @total
json.price_rules @objects do |object|
	json.id 								object.id 
	json.calendar_id 	object.calendar_id
	json.calendar_title object.calendar.title
	
	
	
	json.rule_case_name object.rule_case_name 

	
	json.hour_start object.hour_start 
	json.hour_end object.hour_end 
	json.amount object.amount
	
	json.is_monday object.is_monday
	json.is_tuesday object.is_tuesday
	json.is_wednesday object.is_wednesday
	json.is_thursday object.is_thursday
	json.is_friday object.is_friday
	json.is_saturday object.is_saturday
	json.is_sunday object.is_sunday
	 
	

	
end
