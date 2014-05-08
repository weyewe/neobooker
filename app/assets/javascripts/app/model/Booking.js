Ext.define('AM.model.Booking', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
		{ name: 'calendar_id', type: 'int' },
		{ name: 'customer_id', type: 'int' },

			// Booker 
			{ name: 'customer_name', type: 'string' }  ,
			{ name: 'booking_datetime', type: 'string' },
			
			
			{ name: 'facility_title', type: 'string' } ,

			// Booking details 
			{ name: 'start_datetime', type: 'string' },
    	{ name: 'end_datetime', type: 'string' } ,
			{ name: 'number_of_hours', type: 'int' },
			{ name: 'total_price', type: 'string' },
			{ name: 'discount', type: 'string' },

			{ name: 'title', type: 'string' } ,
			
			{ name: 'booking_code', type: 'string' } ,
			{ name: 'confirmation_code', type: 'string' } ,
			{ name: 'remaining_payment_code', type: 'string' } ,
			
			
			// Confirmation Details 
			{ name: 'is_confirmed', type: 'boolean' } ,
			{ name: 'downpayment_amount', type: 'string'},
			
			// Actual 
			{ name: 'actual_start_datetime', type: 'string' },
    	{ name: 'actual_end_datetime', type: 'string' },


			// Payment Details 
			{ name: 'is_paid', type: 'boolean' } ,
			{ name: 'remaining_amount', type: 'string'},
			
			{ name : 'is_downpayment_imposed' , type : "boolean"},
			{ name : 'is_salvaged' , type : "boolean"}

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
		},
		
		awesomeDate : "2014-7-7"
	
  
});
