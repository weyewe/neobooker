// strategy: before load, setLoading = true on the calendar
// afterLoad + all events are rendered, setLoading == false on the calendar

Ext.define("AM.controller.BasicCalendarWrappers", {
	extend : "Ext.app.Controller",
	stores: ['Events'],
	views : [
		"calendar.BasicCalendarWrapper",
		'Viewport'  
		
	],
	 
	
	refs: [
		{
			ref: 'viewport',
			selector: 'vp'
		} ,
		{
			ref : 'basicCal',
			selector : 'basicCalendarWrapper'
		},
		
		{
			ref : 'theCalendarPanel',
			selector : 'basicCalendarWrapper extensible.calendarpanel'
		},
		
		{
			ref : 'theDatePicker',
			selector : 'basicCalendarWrapper datepicker'
		},
		
		
	],
	 
	 
	init : function( application ) {
		console.log("[INIT Controller]");
		
		console.log("The constant's content is : " + AM.view.Constants['moron'] ) ;
		var me = this; 
		me.control({
		 
			'vp' : {
				'render' : this.onViewportLoaded,
				// 'eventsStoreLoaded' : this.onEventsStoreLoaded,
				// 'beforeEventsStoreLoad' : this.beforeEventsStoreLoaded
			} ,
			
			
			// all these shite doesn't work for extensibleCalendarPanel since it is 
			// not initialized during this control definition.
			'extensibleCalendarPanel' : {
				// 'beforerender': this.addEventStoreToCalendar,
				// 'viewchange' : this.alertViewChange,
				// 'datechange' : this.alertDateChange,
				// 'beforedatechange' : this.alertBeforeDateChange,
				// 'eventsrendered' : this.alertAfterEventsRendered,
				// 'dayclick' : this.onDayClick, 
				// 'eventclick' : this.onEventClick
			},
			'basicCalendarWrapper datepicker' : {
				'select': this.onDatePickerSelected 
			}
			
		});
		
		console.log("[init controller] Init is finished");
	},
	
	onViewportLoaded: function(){
		console.log("============> The onViewportLoaded is not working");
		var datepicker = this.getTheDatePicker();
		console.log("The datepicker: " + datepicker);
		
		var calendarPanel = this.getTheCalendarPanel();
		console.log("The calendar Panel: " + calendarPanel);
		
		console.log("The calendar wrapper");
		var basicCal = this.getBasicCal(); 
		console.log(basicCal);
		
		
		// Ext.ComponentQuery.query("basicCalendarWrapper extensible.calendarpanel")
		
		// Ext.ComponentQuery.query("extensible.calendarpanel")
		// Ext.ComponentQuery.query("extensibleCalendarPanel")
		
		// Ext.ComponentQuery.query("extensible.calendarlist") 
		
		
		
	 
	},
	
	onDatePickerSelected: function(dp, dt){
		console.log("On date picker selected");
		// Ext.getCmp only works by ID 
		var calPanel = Ext.getCmp("extensibleCalendarPanel");
		calPanel.setStartDate(dt); 
  },
  
	alertViewChange: function(cPanel, view, object){
		console.log("View Change")
		cPanel.setLoading = true; 
		var me = this; 
		// alert("The view is changed");
		// console.log("The alertViewChange");
		// console.log("The cPanel");
		// console.log( cPanel );
		// console.log("The view");
		// console.log(view);
		// 
		// console.log("The object");
		// console.log( object); 
		// console.log("The viewStart: ")
		// console.log( object.viewStart); 
		// console.log("The viewStart inspect"); 
		// console.log(  + object.viewStart.getDate() );
		// console.log("The year: " + object.viewStart.getYear() );
		// console.log("The month: " + object.viewStart.getMonth()  ) ;
		// console.log("The day: " + object.viewStart.getDay() ) ;
		
		viewStart = Ext.Date.format(object.viewStart, 'Y-m-d');
		viewEnd = Ext.Date.format(object.viewEnd, 'Y-m-d');
		// console.log("The value viewStart: " + viewStart);
		
		
		// load : function(o) {
		//         Extensible.log('store load');
		//         o = o || {};
		//         
		//         // if params are passed delete the one-time defaults
		//         if(o.params){
		//             delete this.initialParams;
		//         }
		//         // this.initialParams will only be set if the store is being loaded manually
		//         // for the first time (autoLoad = false) so the owning calendar view set
		//         // the initial start and end date params to use. Every load after that will
		//         // have these params set automatically during normal UI navigation.
		//         if(this.initialParams){
		//             o.params = o.params || {};
		//             Ext.apply(o.params, this.initialParams);
		//             delete this.initialParams;
		//         }
		//         
		//         this.callParent(arguments);
		//     }
		// 
		// 
		// me.getEventsStore().getProxy().extraParams = {
		//     startDate: viewStart,
		// 		endDate : viewEnd
		// };
	 
		// me.getEventsStore().load({
		//     startDate: viewStart,
		// 		endDate : viewEnd
		// });
		
		// me.getEventsStore().load(); 
		
		// if( view.reloadStore ){
		// 	view.reloadStore(); 
		// }
		
	},
	
 
  
});