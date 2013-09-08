Ext.define('AM.view.master.Facility', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.facilityProcess',
	 
		
		
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		
		items : [
			{
				xtype : 'facilitylist' ,
				flex : 1 //,
				// html : 'hahaha'
			},
			{
				xtype :'pricerulelist',
				// html : "This is gonna be the price_rule",
				flex : 1
			} 
		],
		
		selectedObject : null, 
		selectedChild : null 
});