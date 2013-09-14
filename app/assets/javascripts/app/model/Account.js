Ext.define('AM.model.Account', {
    extend: 'Ext.data.Model',

    fields: [
        { name: 'id', type: 'int' },

				{ name: 'parent_id', type: 'int' },
				{ name: 'parent_name', type: 'string' },
        { name: 'name' },
        // if we are using local storage, we need to persist the index field so the ordering of tree nodes will be preserved
        // {name: 'index', type: 'int', defaultValue: null, persist: !!SimpleTasksSettings.useLocalStorage}
				// {name: 'index', type: 'int', defaultValue: null, persist: false },
				{name : 'account_case' , type : 'int'},
				{name : 'account_case_text' , type : 'string'},
				
				{name : 'amount' , type : 'string'},
				{name : 'normal_balance_text' , type : 'string'},
				{name : 'contra_account_text' , type : 'string'},
				{ name: 'is_contra_account', type:'boolean' },
					{ name: 'original_account_id', type:'int' }
    ],

  	idProperty: 'id' ,proxy: {
			url: 'api/accounts',
			type: 'rest',
			format: 'json',

			reader: {
				root: 'accounts',
				successProperty: 'success',
				totalProperty : 'total'
			},

			writer: {
				getRecordData: function(record) {
					return { account : record.data };
				}
			}
		}
		
		    // 
		    // 
		    // proxy: SimpleTasksSettings.useLocalStorage ? {
		    //     type: 'localstorage',
		    //     id: 'SimpleTasks-List'
		    // } : {
		    //     type: 'ajax',
		    //     api: {
		    //         create: 'php/list/create.php',
		    //         read: 'php/list/read.php',
		    //         update: 'php/list/update.php',
		    //         destroy: 'php/list/delete.php'
		    //     },
		    // 
		    //     reader: {
		    //         type: 'json',
		    //         messageProperty: 'message'
		    //     }
		    // }
});

// 
// 
// Ext.define('AM.model.User', {
//   	extend: 'Ext.data.Model',
//   	fields: [
//     	{ name: 'id', type: 'int' },
// 			{ name: 'role_id', type: 'int' },
//     	{ name: 'name', type: 'string' } ,
// 			'email',
// 			'role_name' 
//   	],
// 
// 	 
// 
// 
//    
		//   	idProperty: 'id' ,proxy: {
		// 	url: 'api/app_users',
		// 	type: 'rest',
		// 	format: 'json',
		// 
		// 	reader: {
		// 		root: 'users',
		// 		successProperty: 'success',
		// 		totalProperty : 'total'
		// 	},
		// 
		// 	writer: {
		// 		getRecordData: function(record) {
		// 			return { user : record.data };
		// 		}
		// 	}
		// }
// 	
//   
// });
