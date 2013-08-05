json.success true 
json.total @total
json.calendars @objects do |object|
	json.id 								object.id 

	json.title 		 object.title
	json.color 			object.color
	
	json.downpayment_percentage object.downpayment_percentage.to_s
	json.amount object.amount.to_s    
end
