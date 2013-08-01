Ext.define('AM.model.Booking', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'start_datetime', type: 'string' },
    	{ name: 'end_datetime', type: 'string' } ,
			{ name: 'title', type: 'string' } ,
			{ name: 'customer_name', type: 'string' }  
  	],

	  
		


   
  	idProperty: 'id' ,proxy: {
			url: 'api/bookings',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'bookings',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { booking : record.data };
				}
			}
		}
	
  
});
