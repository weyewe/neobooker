Ext.define('AM.model.TransactionActivity', {
    extend: 'Ext.data.Model',

    fields: [
        { name: 'id', type: 'int' },

				{ name: 'transaction_source_id', type: 'int' },
				{ name: 'transaction_source_type', type: 'string' }, 


				{ name: 'description' , type : 'string'},
				{ name: 'transaction_datetime', type: 'string' },
				{ name: 'amount', type: 'string' }
    ],

  	idProperty: 'id' ,proxy: {
			url: 'api/transaction_activities',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'transaction_activities',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { transaction_activity : record.data };
				}
			}
		}
		 
});
