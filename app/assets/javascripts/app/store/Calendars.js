// Ext.define('AM.store.Calendars', {
// 			// model: 'Extensible.calendar.data.EventModel',
// 			extend: 'Extensible.calendar.data.MemoryCalendarStore',
//      // data : Extensible.calendar.data.Calendars.getData()  
// 
// 			data: Extensible.example.calendar.data.CalendarsCustom.getData()
// 			 
// });


// Ext.define('AM.store.Events', {
// 			// model: 'Extensible.calendar.data.EventModel',
// 			extend: 'Extensible.calendar.data.MemoryEventStore',
//      // data :  Extensible.calendar.data.Events.getData() ,
// 
// 			data: Extensible.example.calendar.data.EventsCustom.getData(),
// 			 
// });
// 
// 
// this.eventStore = Ext.create("Extensible.calendar.data.EventStore", {
//     id: "event-store",
//     proxy: this.eventProxy,
//     autoLoad: true
// });

Ext.define('AM.store.Calendars', {
			model: 'Extensible.calendar.data.CalendarModel',
			extend: 'Ext.data.Store',
			id: "calendar-store", 
			
	    autoLoad: false,
	
			// idProperty: 'calendar_id' ,
			
			
			
			proxy: {
				url: 'api/calendars',
				type: 'rest',
				format: 'json',

				reader: {
					root: 'calendars',
					successProperty: 'success',
					totalProperty : 'total'
				},

				writer: {
					getRecordData: function(record) {
						return { calendar : record.data };
					}
				}
			}
			
			
			
	
});
