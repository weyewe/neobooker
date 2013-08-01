Ext.define('AM.model.Facility', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'title', type: 'string' },
    	{ name: 'description', type: 'string' } , 
			{ name: 'color', type: 'int' } , 
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/calendars',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'calendars',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { calendar : record.data };
				}
			}
		}
	
  
});
