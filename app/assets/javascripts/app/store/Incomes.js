Ext.define('AM.store.Incomes', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Income'],
	model: 'AM.model.Income',
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
