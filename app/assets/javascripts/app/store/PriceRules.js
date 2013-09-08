Ext.define('AM.store.PriceRules', {
	extend: 'Ext.data.Store',
	require : ['AM.model.PriceRule'],
	model: 'AM.model.PriceRule',
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
