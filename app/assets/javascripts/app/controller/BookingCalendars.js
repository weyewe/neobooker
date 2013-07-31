// strategy: before load, setLoading = true on the calendar
// afterLoad + all events are rendered, setLoading == false on the calendar

Ext.define("AM.controller.BookingCalendars", {
	extend : "Ext.app.Controller",
	stores: ['Events', 'Calendars'],
	views : [
		"BookingCalendar",
		'calendar.BookingCalendarPanel',
		'calendar.FacilityList',
		'Viewport' 
	],
	 
	
	refs: [
		{
			ref: 'viewport',
			selector: 'vp'
		} ,
		{
			ref : 'calendarPanel',
			selector : 'bookingCalendar bookingCalendarPanel'
		},
		{
			ref : 'calendarList',
			selector : 'bookingCalendar facilityList'
		}
	],
	
 
	
	 
	
	init : function( application ) {
		var me = this; 
		me.control({
		 
			'viewport' : {
				'render' : this.onViewportLoaded,
				'eventsStoreLoaded' : this.onEventsStoreLoaded,
				'beforeEventsStoreLoad' : this.beforeEventsStoreLoaded,
				// "authenticateSuccess" : this.onAuthenticateSuccess,
				"loadCalendar" : this.reloadCalendar
				// 'loginSuccess' : this.loginSuccess
			} ,
			
			'bookingCalendar bookingCalendarPanel' : {
				'viewchange' : this.alertViewChange,
				// 'render' : this.beforeBookingCalendarPanelRender, 
				// 'datechange' : this.alertDateChange,
				// 'beforedatechange' : this.alertBeforeDateChange,
				// 'eventsrendered' : this.alertAfterEventsRendered,
				// 'dayclick' : this.onDayClick, 
				// 'eventclick' : this.onEventClick
			},
			
			'bookingCalendar facilityList' : {
				'click' : this.onFacilityListClicked,
				// 'render' : this.beforeFacilityListRendered,
				// 'activate' : this.beforeFacilityListRendered,
				// 'datechange' : this.alertDateChange,
				// 'beforedatechange' : this.alertBeforeDateChange,
				// 'eventsrendered' : this.alertAfterEventsRendered,
				// 'dayclick' : this.onDayClick, 
				// 'eventclick' : this.onEventClick
			},
			'bookingCalendar datepicker' : {
				'select': this.onDatePickerSelected 
			}
			
		});
		
		// console.log("Init is finished");
	},
	
	reloadCalendar: function(){
		console.log("The login is SUCCESS");
		// this.beforeBookingCalendarPanelRender();
		// this.beforeFacilityListRendered();
		
		Ext.ComponentQuery.query("bookingCalendarPanel")[0].store.reload();
		Ext.ComponentQuery.query("facilityList")[0].store.reload();
	},
	
	beforeBookingCalendarPanelRender: function(){
		// var calPanel  = this.getCalendarPanel(); 
		// calPanel.getActiveView().reloadStore();
		
		
		// calPanel.doLayout();
	},
	
	 
	beforeFacilityListRendered: function(){
		var fList = 
		fList.store.reload();  // => do this, and it will auto refresh itself.
		// fList.doLayout();
	},
	
	
	onViewportLoaded: function(){
		// console.log("THE VIEWPORT IS LOADED");
		// this.getCalendarPanel().store.load(); 
		// var calPanel = this.getCalendarPanel
		
		// load the first page from the server 
		// var calPanel  = this.getCalendarPanel(); 
		// 		calPanel.getActiveView().reloadStore(); 
		
		// check whether there is facility list
		// var fList = this.getCalendarList();
		// console.log("**************+++++++++ -> The calendarLIST");
		// console.log( fList ) ;
		
		
		// console.log("Before reloading calendar store")
		// var calendarStore = this.getCalendarsStore();
		// console.log(calendarStore);
		// calendarStore.reload();
		// var calList = this.getCalendarList()  ;
		// console.log("THe calendar LIST ");
		// console.log( calList ) ;
		
		
		// var fList = Ext.ComponentQuery.query("facilityList")[0]
			// // Case: autoLoad : true 
			// There is something inside fList.body 
			// fList.body
			// constructor {dom: div#facilityList-1013-body.x-panel-body x-panel-body-default x-panel-body-default x-layout-fit, 
			// 		id: "facilityList-1013-body", $cache: Object, lastBox: Object, self: function…}
			// 	
			
			// // Case autoLoad : false
			// There is something inside fList.body
			// constructor {dom: div#facilityList-1013-body.x-panel-body x-panel-body-default 
			// 	x-panel-body-default x-layout-fit, id: "facilityList-1013-body",
			//  	$cache: Object, lastBox: Object, self: function…}
			
		// fList.store.reload()  => do this, and it will auto refresh itself. 
		
	},
	
	
	onFacilityListClicked: function(el){
		// console.log("Facility list is clicked");
		// console.log(el);
	},
	
	
	onDatePickerSelected: function(dp, dt){
		console.log("The date picker is selected");
			var calendarPanel = this.getCalendarPanel();
			calendarPanel.setStartDate(dt); 
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
		// console.log("[calendarPanel] View Change");
		// alert("THe view change");
		// cPanel.setLoading = true; 
		// var me = this; 
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
		
		// viewStart = Ext.Date.format(object.viewStart, 'Y-m-d');
		// viewEnd = Ext.Date.format(object.viewEnd, 'Y-m-d');
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