Ext.define("AM.controller.Navigation", {
	extend : "Ext.app.Controller",
	views : [
		"Content"
	],
	
 
	
	refs: [
		{
			ref: 'viewport',
			selector: 'vp'
		} ,
		{
			ref : 'content',
			selector : 'content'
		}
	],
	
	  
	
	 
	
	init : function( application ) {
		var me = this; 
		
		
		// console.log("INSIDE init of Navigation.js");
		me.control({  
			'	button[action=switchCalendar]' : {
				click : me.switchScreen
			},
			'	button[action=switchBooking]' : {
				click : me.switchScreen
			},
			'	button[action=switchReport]' : {
				click : me.switchScreen
			},
			'	button[action=switchAccounting]' : {
				click : me.switchScreen
			}
			
			
		});
	},
 

	switchScreen: function(btn){
		var me = this; 
		
		var activeItem = AM.view.Constants[ btn.action ] ;
		// console.log("The activeItem : " + activeItem);
		me.getContent().layout.setActiveItem( AM.view.Constants[ btn.action ] )
		
		if(btn.action ==='switchCalendar'){
			me.getViewport().fireEvent("loadCalendar");
		}
 
	}
	 
	   
});