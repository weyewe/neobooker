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
						console.log("Inside the listener of calendar");
					}
				}

			},
			{
				iconCls: 'tasks-mark-complete',
				id: 'mark-complete-btn',
				disabled: false,
				tooltip: 'Bookings',
				xtype: 'button',
				text : "Bookings",
				action : "switchBooking"
			},
			{
				iconCls: 'tasks-mark-active',
				id: 'mark-active-btn',
				disabled: false,
				tooltip: 'Report',
				xtype: 'button',
				text : "Report",
				action : "switchReport"
			},
			{
				iconCls: 'tasks-mark-active',
				id: 'mark-master-btn',
				disabled: false,
				tooltip: 'Master Data',
				xtype: 'button',
				text : "Master Data",
				action : "switchMaster"
			},
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
