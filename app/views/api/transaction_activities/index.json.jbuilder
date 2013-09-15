json.success true 
json.total @total
json.transaction_activities @objects do |object|
	json.id 												object.id 
	json.transaction_source_id 			object.transaction_source_id
	json.transaction_source_type 		object.transaction_source_type

	json.description 								object.description
	json.transaction_datetime 			format_date_friendly( object.transaction_datetime ) 
	json.amount 										object.amount 
	json.is_confirmed 										object.is_confirmed 

	
	
end
