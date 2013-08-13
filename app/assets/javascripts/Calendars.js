// strategy: before load, setLoading = true on the calendar
// afterLoad + all events are rendered, setLoading == false on the calendar

Ext.define("AM.controller.Calendars", {
	extend : "Ext.app.Controller",
	stores: ['Events'],
	views : [
		"calendar.Basic",
		'Viewport' 
	],
	 
	
	refs: [
		{
			ref: 'viewport',
			selector: 'vp'
		} ,
		{
			ref : 'basicCal',
			selector : 'basicCalendar'
		}
	],
	
 
	onLaunch : function(){
	 
		
	},
	
	
	onViewportLoaded: function(){
	},
	
	addEventStoreToCalendar: function(){ 
	},
	
	init : function( application ) {
		var me = this; 
		me.control({
		 
			'vp' : {
				'render' : this.onViewportLoaded,
				'eventsStoreLoaded' : this.onEventsStoreLoaded,
				'beforeEventsStoreLoad' : this.beforeEventsStoreLoaded
			} ,
			
			'basicCalendar' : {
				'beforerender': this.addEventStoreToCalendar,
				'viewchange' : this.alertViewChange,
				'datechange' : this.alertDateChange,
				'beforedatechange' : this.alertBeforeDateChange,
				'eventsrendered' : this.alertAfterEventsRendered,
				// 'dayclick' : this.onDayClick, 
				'eventclick' : this.onEventClick
			},
			'vp datepicker' : {
				'select': this.onDatePickerSelected 
			}
			
		});
		
		// console.log("Init is finished");
	},
	
	
	onDatePickerSelected: function(dp, dt){
			var basicCal = this.getBasicCal();
			basicCal.setStartDate(dt); 
  },
 
	onDayClick: function(){
		// console.log("On day click");
	},
	
	onEventClick : function(){
		// console.log("on event click");
	},
	
	
	onEventsStoreLoaded : function(sender){  
		var me = this;
		// Ext.getCmp('indicator').setLoading(false);
		me.getViewport().setLoading(false);
	},
	
	beforeEventsStoreLoaded: function(sender){ 
		var me = this;
		// Ext.getCmp('indicator').setLoading(true);
		me.getViewport().setLoading(true);
	},
	 
	alertAfterEventsRendered: function( cPanel ){
		// console.log("After Events Rendered");
		cPanel.setLoading = false ; 
	},
	alertViewChange: function(cPanel, view, object){
		// console.log("View Change")
		cPanel.setLoading = true; 
		var me = this; 
	
		viewStart = Ext.Date.format(object.viewStart, 'Y-m-d');
		viewEnd = Ext.Date.format(object.viewEnd, 'Y-m-d');
	
		
	},
	
	// ( Extensible.calendar.CalendarPanel this, Date startDate, Date viewStart, Date viewEnd )
	alertDateChange: function(cPanel, startDate, viewStart, viewEnd ){
		// alert("The date is changed")
		// console.log("The dateChange");
		// console.log(startDate);
		// console.log(viewStart);
		// console.log( viewEnd);
	},
	
	// beforedatechange : ( Extensible.calendar.CalendarPanel this, Date startDate, Date newStartDate, Date viewStart, Date viewEnd )
	
	alertBeforeDateChange: function(cPanel, startDate, newStartDate, viewStart, viewEnd){
		// console.log("The alertBeforeDateChange");
		// console.log(startDate);
		// console.log( newStartDate);
		// console.log(viewStart);
		// console.log( viewEnd);
	}
  
});