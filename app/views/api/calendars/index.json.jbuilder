json.success true 
json.total @total
json.calendars @objects do |object|
	json.cal_id 								object['cal_id'] 

	json.cal_title 		 object['cal_title']  
	json.cal_color 			object['cal_color']     
end
