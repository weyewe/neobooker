Ext.define('AM.model.TransactionActivityEntry', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'transaction_activity_id', type: 'int' }, 
			{ name: 'account_id', type: 'int' }, 
			{ name: 'account_name', type: 'string' }, 
			
			{ name: 'entry_case', type: 'int' }, 
			{ name: 'entry_case_text', type: 'string' },
			
			{ name: 'amount', type: 'string' },
			
			{ name: 'is_bank_transaction', type: 'boolean' },
 	
  	],


 
  	idProperty: 'id' ,proxy: {
			url: 'api/transaction_activity_entries',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'transaction_activity_entries',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { transaction_activity_entry : record.data };
				}
			}
		}
	
  
});
