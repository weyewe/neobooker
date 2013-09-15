Ext.define('AM.store.TransactionActivityEntries', {
	extend: 'Ext.data.Store',
	require : ['AM.model.TransactionActivityEntry'],
	model: 'AM.model.TransactionActivityEntry',
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
