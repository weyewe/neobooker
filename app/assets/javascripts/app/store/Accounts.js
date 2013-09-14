Ext.define('AM.store.Accounts', {
    extend: 'Ext.data.TreeStore',
    model: 'AM.model.Account',

		autoLoad : false, 
		autoSync: false,
    // root: {
    //     expanded: true,
    //     id: -1,
    //     name: 'Accounts'
    // }

		root: {
		        expanded: true,
		        // id: -1,
		        name: 'Accounts'
		    }
});

// 
// Ext.define('AM.store.Bookings', {
// 	extend: 'Ext.data.Store',
// 	require : ['AM.model.Booking'],
// 	model: 'AM.model.Booking',
// 	// autoLoad: {start: 0, limit: this.pageSize},
// 	autoLoad : false, 
// 	autoSync: false,
// 	pageSize : 10, 
// 	
// 	sorters : [
// 		{
// 			property	: 'id',
// 			direction	: 'DESC'
// 		}
// 	], 
// 	listeners: {
// 
// 	} 
// });
