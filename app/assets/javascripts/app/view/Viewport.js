Ext.define("AM.view.Viewport" , {
	extend : "Ext.container.Viewport",
	alias : 'widget.vp',
	
	
	layout : {
		type : 'card'
	},
	
	items  : [
		{
			xtype : 'authform'
		},
		{
			xtype : 'protectedcontent' 
		}
	]
	
		// 
		// layout : {
		// 	type : 'vbox',
		// 	align : 'stretch'
		// },
		// 
		//  
		// items  : [
		// 	// {
		// 	// 	text : "First",
		// 	// 	xtype : 'button',
		// 	// 	flex : 1,
		// 	// 	id : 'indicator',
		// 	// 	listeners: {
		// 	// 		click: function() {
		// 	// 			var widget = Ext.widget("window");
		// 	// 			widget.show();
		// 	// 
		// 	// 		}
		// 	// 	}
		// 	// }, 
		// 	{
		// 		html : "First",
		// 		xtype : 'container',
		// 		flex : 1,
		// 		id : 'indicator' 
		// 	},
		// 	
		// 	// {
		// 	// 	xtype: 'extensible.calendarlist',
		// 	//       store: Ext.create('AM.store.Calendars')
		// 	// },
		// 	
		// 	
		// 	{
		// 		xtype : 'bookingCalendar',
		// 		flex : 5 
		// 	}
		// 	
		// 	// {
		// 	// 	xtype : 'panel',
		// 	// 	flex :  5, 
		// 	// 	layout : {
		// 	// 		type : 'hbox',
		// 	// 		align : 'stretch'
		// 	// 	},
		// 	// 	items : [
		// 	// 		{
		// 	// 			flex : 1,
		// 	// 			xtype: 'datepicker' 
		// 	// 		},
		// 	// 		
		// 	// 		{
		// 	// 			xtype: 'basicCalendar', 
		// 	// 			flex: 5 
		// 	// 		}
		// 	// 	]
		// 	// }
		// ]
});
