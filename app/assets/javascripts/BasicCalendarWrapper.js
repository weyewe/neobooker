Ext.define('AM.view.calendar.BasicCalendarWrapper', {
    extend: 'Ext.panel.Panel',
		alias : 'widget.basicCalendarWrapper',
    title: 'Basic  Haha Calendar' , 
		id: 'basicWrapper',
		
		layout : {
			type : 'hbox',
			align : 'stretch'
		},

		initComponent: function(){ 
			
			console.log("Init component basic calendar wrapper");
			
			var me = this; 
			var calendar = this;  
			
			
			me.createCalendarStore(); 
			me.createEventStore();
			
			
			
			me.buildCalendarPanel(); 
			
			
			this.callParent( arguments );
		},
		
		buildSidePanel: function(){
			console.log("[START] building side panel");
			
			var me = this; 
			me.sidePanel = {
				xtype : 'panel',
				layout : {
					type : 'vbox',
					align : 'stretch'
				},
				flex : 1 , 
				items : [
					{
						xtype: 'datepicker' 
					},
					{
						xtype: 'extensible.calendarlist',
            store: me.calendarStore, 
					}
				]
			}
			
			console.log("[Tue]THEEE calendar store: " + me.calendarStore);
			console.log(  me.calendarStore);
			console.log("[END] building side panel");
		},
		
		
		
		buildMainPanel: function(){
			console.log("[START] building main panel");
			var me = this; 
			me.mainPanel = {
				xtype : 'extensible.calendarpanel',
				eventStore : me.eventStore, 
				calendarStore : me.calendarStore,
				flex : 5 ,
				id : 'extensibleCalendarPanel',
				readOnly : true, 
			}
			
			console.log("[END] building main panel");
		},
		
		
		
		buildCalendarPanel: function(){
			var me = this; 
			me.buildSidePanel();
			me.buildMainPanel();
			
			me.items = [
				me.sidePanel, 
				me.mainPanel
			]
		},
		
		
		createEventStore: function(){
			this.eventStore = Ext.create('AM.store.Events');
			
 			this.eventStore.addListener('load', function(store, operation, calendar, resultObject ){
				var viewport = Ext.ComponentQuery.query('viewport')[0];
				viewport.fireEvent("eventsStoreLoaded");
 			}); 

 			this.eventStore.addListener('beforeload', function(store,operation, resultObject ){
				var viewport = Ext.ComponentQuery.query('viewport')[0];
				viewport.fireEvent("beforeEventsStoreLoad");
 			});
		},
		
		createCalendarStore: function(){
			this.calendarStore =  Ext.create('AM.store.Calendars');
		}
});