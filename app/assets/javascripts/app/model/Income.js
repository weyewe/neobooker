Ext.define('AM.model.Income', {
  	extend: 'Ext.data.Model',
		fields: [
			{ name: 'id', type: 'int' },
			{ name: 'income_source_id', type: 'int' },
			{ name: 'income_source_type', type: 'string' },
			{ name: 'code', type: 'string' },
			{ name: 'amount', type: 'string'},
			{ name: 'transaction_datetime', type: 'string'},
		],

  	idProperty: 'id' ,proxy: {
			url: 'api/incomes',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'incomes',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { income : record.data };
				}
			}
		}
	
  
});
