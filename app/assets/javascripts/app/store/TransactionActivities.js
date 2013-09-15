Ext.define('AM.store.TransactionActivities', {
	extend: 'Ext.data.Store',
	require : ['AM.model.TransactionActivity'],
	model: 'AM.model.TransactionActivity',
	// autoLoad: {start: 0, limit: this.pageSize},
	autoLoad : false, 
	autoSync: false,
	pageSize : 20, 
	
	sorters : [
		{
			property	: 'id',
			direction	: 'DESC'
		}
	], 
	listeners: {

	} 
});
