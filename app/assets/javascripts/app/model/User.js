Ext.define('AM.model.User', {
  	extend: 'Ext.data.Model',
  	fields: [
    	{ name: 'id', type: 'int' },
			{ name: 'role_id', type: 'int' },
    	{ name: 'name', type: 'string' } ,
			'email',
			'role_name' 
  	],

	 


   
  	idProperty: 'id' ,proxy: {
			url: 'api/app_users',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'users',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { user : record.data };
				}
			}
		}
	
  
});
