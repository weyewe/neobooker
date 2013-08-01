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

Ext.define('AM.store.Events', {
			// model: 'Extensible.calendar.data.EventModel',
			extend: 'Extensible.calendar.data.EventStore',
			id: "event-store", 
			
	    autoLoad: false,
	
			idProperty: 'id' ,
			 
			
			proxy: {
				// url: 'api/bookings',
				url: 'api/events',
				type: 'rest',
				format: 'json',

				reader: {
					// root: 'bookings',
					root: 'events',
					successProperty: 'success',
					totalProperty : 'total'
				},

				writer: {
					getRecordData: function(record) {
						// return { booking : record.data };
						return { 'event' : record.data };
					}
				}
			}
			
			
			
	
});