Ext.define('AM.controller.Bookings', {
  extend: 'Ext.app.Controller',

  stores: ['Bookings'],
  models: ['Booking'],

  views: [
    'booking.booking.List',
    'booking.booking.Form',
		'booking.booking.ConfirmationForm',
		'booking.booking.UpdateStartTimeForm'
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'bookinglist'
		} 
	],

  init: function() {
    this.control({
      'bookinglist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'bookingform button[action=save]': {
        click: this.updateObject
      },
      'bookinglist button[action=addObject]': {
        click: this.addObject
      },
      'bookinglist button[action=editObject]': {
        click: this.editObject
      },
      'bookinglist button[action=deleteObject]': {
        click: this.deleteObject
			}	,
			'bookinglist button[action=confirmObject]': {
        click: this.confirmObject
			}	,
			
			'bookinglist button[action=startObject]': {
        click: this.startObject
			}	,
			'bookinglist button[action=endObject]': {
        click: this.endObject
			}	,
			'bookinglist button[action=payObject]': {
        click: this.payObject
			}	,
			
			'bookinglist textfield[name=searchField]': {
				change: this.liveSearch
			},
			
			'confirmbookingform button[action=confirm]' : {
				click : this.executeConfirm
			},
			'startbookingform button[action=save]' : {
				click : this.executeStartBooking
			},
			'endbookingform button[action=save]' : {
				click : this.executeEndBooking
			},
			'paybookingform button[action=pay]' : {
				click : this.executePayBooking
			}
		
    });
  },

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getBookingsStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getBookingsStore().load();
	},
 

	loadObjectList : function(me){
		// console.log("************* IN THE USERS CONTROLLER: afterRENDER");
		me.getStore().load();
	},

  addObject: function() {
    var view = Ext.widget('bookingform');
    view.show();
  },

  editObject: function() {
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('bookingform');


		console.log("Gonna load record");
		console.log( record  ) ;
    view.down('form').loadRecord(record);
		// view.setComboBoxData(record); 
  },

  updateObject: function(button) {
    var win = button.up('window');
    var form = win.down('form');

    var store = this.getBookingsStore();
    var record = form.getRecord();
    var values = form.getValues();

		console.log("The values: " ) 
		console.log( values ) ;
		
		if( record ){
			record.set( values );
			 
			form.setLoading(true);
			record.save({
				success : function(record){
					form.setLoading(false);
					//  since the grid is backed by store, if store changes, it will be updated
					store.load();
					win.close();
				},
				failure : function(record,op ){
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					this.reject();
				}
			});
				
			 
		}else{
			//  no record at all  => gonna create the new one 
			var me  = this; 
			var newObject = new AM.model.Booking( values ) ;
			
			// learnt from here
			// http://www.sencha.com/forum/showthread.php?137580-ExtJS-4-Sync-and-success-failure-processing
			// form.mask("Loading....."); 
			form.setLoading(true);
			newObject.save({
				success: function(record){
					//  since the grid is backed by store, if store changes, it will be updated
					store.load();
					form.setLoading(false);
					win.close();
					
				},
				failure: function( record, op){
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					this.reject();
				}
			});
		} 
  },

  deleteObject: function() {
    var record = this.getList().getSelectedObject();

    if (record) {
      var store = this.getBookingsStore();
      store.remove(record);
      store.sync();
// to do refresh programmatically
		this.getList().query('pagingtoolbar')[0].doRefresh();
    }

  },

  selectionChange: function(selectionModel, selections) {
    var grid = this.getList();

		// var currentUser = Ext.decode( localStorage.getItem('currentUser'));

    if (selections.length > 0) {
      grid.enableRecordButtons();


    } else {
      grid.disableRecordButtons();
    }
  },

	confirmObject : function(){
		var view = Ext.widget('confirmbookingform');
		var record = this.getList().getSelectedObject();
		view.setParentData( record );
    view.show();
	},
	
	
	
	executeConfirm : function(button){
		alert("Yeah, gonna execute confirm");
	}	,
	
	
	startObject : function(){
		var view = Ext.widget('startbookingform');
		var record = this.getList().getSelectedObject();
		view.setParentData( record );
    view.show();
	},
	executeStartBooking : function(button){
		alert("Yeah, gonna start the booking");
	},
	
	endObject : function(){
		var view = Ext.widget('endbookingform');
		var record = this.getList().getSelectedObject();
		view.setParentData( record );
    view.show();
	},
	
	executeEndBooking : function(button){
		alert("Yeah, gonna end the booking");
	},
	
	payObject : function(){
		var view = Ext.widget('paybookingform');
		var record = this.getList().getSelectedObject();
		view.setParentData( record );
    view.show();
	},
	
	executePayBooking : function(button){
		alert("Yeah, gonna pay the booking");
	},
});
