Ext.define('AM.view.calendar.Basic', {
    extend: 'Extensible.calendar.CalendarPanel',
		alias : 'widget.basicCalendar',
    title: 'Basic  Haha Calendar' , 
		readOnly : false, 

		initComponent: function(){ 
			
			
			
			var me = this; 
			var calendar = this;  
			
			me.createEventStore();
			me.createCalendarStore(); 
			
			
			
			
			
			
			this.callParent( arguments );
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