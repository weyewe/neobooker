json.success true 
json.total @total
json.transaction_activity_entries @objects do |object|
	json.id 												object.id 
	json.transaction_activity_id 			object.transaction_activity_id 
	
	json.account_id		object.account_id
	json.account_name object.account.name 
	
	json.entry_case object.entry_case
	if object.entry_case == NORMAL_BALANCE[:debit]
		json.entry_case_text "Debit"
	else
		json.entry_case_text "Credit"
	end
	
	json.amount object.amount 
	json.is_bank_transaction object.is_bank_transaction  
end
