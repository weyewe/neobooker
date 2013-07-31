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
		
		
		console.log("INSIDE init of Navigation.js");
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
			'	button[action=switchMaster]' : {
				click : me.switchScreen
			}
			
			
		});
	},
 

	switchScreen: function(btn){
		// console.log('the button is clicked');
		// console.log("The constant: " + AM.view.Constants['GET_USERS_URL']);
		// console.log(btn);
		// console.log(btn.action);
		// 
		var me = this; 
		
		me.getContent().layout.setActiveItem( AM.view.Constants[ btn.action ] )
		
	 if(btn.action ==='switchCalendar'){
		me.getViewport().fireEvent("loadCalendar");
	}
		
		// if( btn.action === 'switchCalendar'){
		// 	me.getContent().layout.setActiveItem(0)
		// }else{
		// 	console.log("It is the other thing");
		// 	me.getContent().layout.setActiveItem(2 );
		// }
	}
	 
	   
});