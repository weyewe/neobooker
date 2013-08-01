Ext.define('AM.view.Content', {
    extend: 'Ext.panel.Panel',
    alias : 'widget.content', 
    
    
		border: false,
		activeItem : 1 ,

		layout: {
			type : 'card',
			align: 'stretch'
		},
		
		items : [
			{
				xtype : 'bookingCalendar',
				// header: false
			},
			{
				xtype : 'bookingProcessPanel'
			},
			{
				// html : "Second",
				html : "second",
				xtype : 'container'
			},
			{
				html : "Third",
				xtype : 'container'
			}
		]
		 
});
