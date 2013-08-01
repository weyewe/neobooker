Ext.define('AM.view.BookingCalendar', {
    extend: 'Ext.panel.Panel',
		alias : 'widget.bookingCalendar',
    // title: 'Booking  Haha Calendar' , 
		// id: 'bookingCalendar',
		
		layout : {
			type : 'hbox',
			align : 'stretch'
		},

		initComponent: function(){ 
			
			// console.log("Init component basic calendar wrapper");
			
			var me = this; 
			var calendar = this;  
			
			
			me.createCalendarStore(); 
			me.createEventStore();
			
			// var range = me.calendarStore.getRange();
			// console.log("THE FUCKING Range: " ) ;
			// console.log( range ) ;
			// var rec = range[0];
			// rec.set( 'Hidden', true);
			// 
			
			me.buildCalendarPanel(); 
			
			
			this.callParent( arguments );
		},
		
		buildSidePanel: function(){
			// console.log("[START] building side panel");
			
			var me = this; 
			me.sidePanel = {
				xtype : 'panel',
				layout : {
					type : 'vbox',
					align : 'stretch'
				},
				flex : 1, 
				items : [
					// {
					// 	xtype: 'datepicker' ,
					// 	border: false ,
					// 	flex : 2 
					// },
					{
						xtype: 'calendarFacilityList',
            store: me.calendarStore, 
						flex : 3 , 
						collapsible : false 
					}
				]
			}
			
			// console.log("[Tue]THEEE calendar store: " + me.calendarStore);
			// console.log(  me.calendarStore);
			// console.log("[END] building side panel");
		},
		
		
		
		buildMainPanel: function(){
			// console.log("[START] building main panel");
			var me = this; 
			me.mainPanel = {
				xtype : 'bookingCalendarPanel',
				eventStore : me.eventStore, 
				calendarStore : me.calendarStore,
				flex : 5 ,
				readOnly : true, 
			}
			
			// console.log("[END] building main panel");
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