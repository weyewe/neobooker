json.success true 
json.total @total
json.accounts @objects do |object|
	json.id 								object.id 
	json.name 	object.name
	
	if @parent
		json.parent_id					@parent.id  
		json.parent_name 				@parent.name 	
	else
		json.parent_id					 ""  
		json.parent_name 				""
	end
	
	
	
	if object.account_case == ACCOUNT_CASE[:ledger] 
		json.leaf true 
		json.account_case ACCOUNT_CASE[:ledger]
		json.account_case_text "Ledger"
	else
		json.leaf false 
		json.account_case ACCOUNT_CASE[:group]
		json.account_case_text "Group"
	end
	
	json.amount object.amount.to_s
	
	if object.normal_balance  ==  NORMAL_BALANCE[:debit]
		json.normal_balance_text  "Debit"
	else
		json.normal_balance_text  "Credit"
	end
	
	json.is_contra_account object.is_contra_account
	json.original_account_id object.original_account_id
	
	if object.is_contra_account  == true 
		json.contra_account_text  "Contra Account"
	else
		json.contra_account_text  ""
	end
	
	 
	

	
end
