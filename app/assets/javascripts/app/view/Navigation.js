Ext.define('AM.view.Navigation', {
    extend: 'Ext.toolbar.Toolbar',
    alias : 'widget.navigation', 
    
   

		items: [
			{
				iconCls: 'tasks-delete-task',
				id: 'delete-task-btn',
				disabled: false,
				tooltip: 'Calendar',
				xtype: 'button',
				text : "Calendar",
				action : "switchCalendar",
				listeners: {
					click: function() {
						// console.log("Inside the listener of calendar");
					}
				},
				toggleGroup: this.id+'-nav-views'

			},
			{
				iconCls: 'tasks-mark-complete',
				id: 'mark-complete-btn',
				disabled: false,
				tooltip: 'Bookings',
				xtype: 'button',
				text : "Bookings",
				action : "switchBooking",
				pressed : true,
				toggleGroup: this.id+'-nav-views'
			},
			// {
			// 	iconCls: 'tasks-mark-active',
			// 	id: 'mark-active-btn',
			// 	disabled: false,
			// 	tooltip: 'Master Data',
			// 	xtype: 'button',
			// 	text : "Master Data",
			// 	action : "switchReport"
			// },
			// {
			// 	iconCls: 'tasks-mark-active',
			// 	id: 'mark-master-btn',
			// 	disabled: false,
			// 	tooltip: 'Report',
			// 	xtype: 'button',
			// 	text : "Report",
			// 	action : "switchMaster"
			// },
			'->',
			{
				text: "Options",
				itemId : 'optionsMenu',
				text : "The email", 
				menu: [
					{
						action: 'editPassword',
						text: "Ganti Password",
						listeners: {
							click: function() {
								var editPasswordWindow = Ext.widget("editPassword");
								editPasswordWindow.show();
							}
						}
					},
					{
						text: "Ganti Profile"
					}
				]
			},
			'-',
			{
				text: 'Logout',
				action: 'logoutUser'  
			}
		]
	 
});
