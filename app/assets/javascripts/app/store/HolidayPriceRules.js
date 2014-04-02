Ext.define('AM.store.HolidayPriceRules', {
	extend: 'Ext.data.Store',
	require : ['AM.model.HolidayPriceRule'],
	model: 'AM.model.HolidayPriceRule',
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
