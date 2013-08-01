Ext.define('AM.store.Bookings', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Booking'],
	model: 'AM.model.Booking',
	// autoLoad: {start: 0, limit: this.pageSize},
	autoLoad : false, 
	autoSync: false,
	pageSize : 10, 
	
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 
	listeners: {

	} 
});
