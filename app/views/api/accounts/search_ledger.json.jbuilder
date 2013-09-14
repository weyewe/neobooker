json.success true 
json.total @total
json.records @objects do |object|
	json.id 						object.id
	json.name 			object.name  
end
