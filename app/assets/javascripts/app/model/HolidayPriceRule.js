Ext.define('AM.model.HolidayPriceRule', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'calendar_id', type: 'int' }, 
		  { name: 'calendar_title', type: 'string' }, 
			{ name : 'rule_case_name', type : 'string'},

	 
			{ name: 'hour_start', type: 'int' },
			{ name: 'hour_end', type: 'int' },
			{ name: 'amount', type: 'string' }, 

	 
			{ name: 'is_monday', type: 'boolean' } , 
			{ name: 'is_tuesday', type: 'boolean' } , 
			{ name: 'is_wednesday', type: 'boolean' } , 
			{ name: 'is_thursday', type: 'boolean' } , 
			{ name: 'is_friday', type: 'boolean' } , 
			{ name: 'is_saturday', type: 'boolean' } , 
			{ name: 'is_sunday', type: 'boolean' } , 
			{ name: 'holiday_date', type: 'string' },
			{ name: 'is_holiday', type: 'boolean' },

  	],

	  
		


   
  	idProperty: 'id' ,proxy: {
			url: 'api/holiday_price_rules',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'holiday_price_rules',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { holiday_price_rule : record.data };
				}
			}
		}
	
  
});
