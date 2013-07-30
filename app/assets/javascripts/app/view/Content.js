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
				html : "First",
				xtype : 'container'
			},
			{
				html : "Second",
				xtype : 'container'
			},
			{
				html : "Third",
				xtype : 'container'
			}
		]
		 
});
