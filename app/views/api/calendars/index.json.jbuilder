json.success true 
json.total @total
json.calendars @objects do |object|
	json.id 								object.id 

	json.title 		 object.title
	json.color 			object.color   
end
