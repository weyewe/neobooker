Ext.define('AM.store.Facilities', {
	extend: 'Ext.data.Store',
	require : ['AM.model.Facility'],
	model: 'AM.model.Facility',
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
