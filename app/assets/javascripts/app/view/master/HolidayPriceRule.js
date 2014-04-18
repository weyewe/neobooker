Ext.define('AM.view.master.HolidayPriceRule', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.holidaypriceruleProcess',
	 
		
		
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		
		items : [
			{
				xtype : 'facilitylist' ,
				allowCRUD: false, 
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'holidaypricerulelist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
		
		selectedObject : null, 
		selectedChild : null 
});