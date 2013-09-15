Ext.define('AM.controller.TransactionActivities', {
  extend: 'Ext.app.Controller',

  stores: ['TransactionActivities'],
  models: ['TransactionActivity'],

  views: [
    'accounting.transactionactivity.List',
    'accounting.transactionactivity.Form',
		// 'accounting.transactionactivityentry.List'
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'transactionactivitylist'
		},
		{
			ref : 'childList',
			selector : 'transactionactivityentrylist'
		},
		
		{
			ref : 'form',
			selector : 'transactionactivityform'
		}
	],

  init: function() {
    this.control({
      'transactionactivitylist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'transactionactivityform button[action=save]': {
        click: this.updateObject
      },
		 
      'transactionactivitylist button[action=addObject]': {
        click: this.addObject
      },
      'transactionactivitylist button[action=editObject]': {
        click: this.editObject
      },
      'transactionactivitylist button[action=deleteObject]': {
        click: this.deleteObject
			}	,
			'transactionactivitylist textfield[name=searchField]': {
				change: this.liveSearch
			}
		
    });
  },
 
	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getTransactionActivitiesStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getTransactionActivitiesStore().load();
	},
 

	loadObjectList : function(me){
		// console.log("************* IN THE USERS CONTROLLER: afterRENDER");
		me.getStore().load();
	},

  addObject: function() {
    var view = Ext.widget('transactionactivityform');
    view.show();
  },

  editObject: function() {
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('transactionactivityform');

    view.down('form').loadRecord(record);
		// view.setComboBoxData(record); 
		// view.setColorPickerData(record)
  },

  updateObject: function(button) {
    var win = button.up('window');
    var form = win.down('form');
		var me = this; 

    var store = this.getTransactionActivitiesStore();
    var record = form.getRecord();
    var values = form.getValues();

		// console.log("Inside updateObject");
		// console.log("The values");
		// console.log(values);
		if( record ){
			record.set( values );
			 
			form.setLoading(true);
			record.save({
				success : function(record){
					form.setLoading(false);
					//  since the grid is backed by store, if store changes, it will be updated
					store.load();
					win.close();
					me.updateChildGrid(record );
				},
				failure : function(record,op ){
					form.setLoading(false);
					var message  = op.request.scope.reader.jsonData["message"];
					var errors = message['errors'];
					form.getForm().markInvalid(errors);
					record.reject();
				}
			});
				
			 
		}else{
			//  no record at all  => gonna create the new one 
			var me  = this; 
			var newObject = new AM.model.TransactionActivity( values ) ;
			
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
					
					me.updateChildGrid(record );
					
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
      var store = this.getTransactionActivitiesStore();
			store.remove(record);
			store.sync( );
 
			this.getList().query('pagingtoolbar')[0].doRefresh();
    }

  },

  selectionChange: function(selectionModel, selections) {
    var grid = this.getList();
		var me= this;
		var record = this.getList().getSelectedObject();
		if(!record){
			return; 
		}
		
		
		me.updateChildGrid(record );
		

    if (selections.length > 0) {
      grid.enableRecordButtons();
    } else {
      grid.disableRecordButtons();
    }
  },

	updateChildGrid: function(record){
		var childGrid = this.getChildList();
		// childGrid.setTitle("Purchase Order: " + record.get('code'));
		// childGrid.setObjectTitle( record ) ;
		childGrid.getStore().load({
			params : {
				transaction_activity_id : record.get('id')
			},
			callback : function(records, options, success){
				
				// var totalObject  = records.length;
				// if( totalObject ===  0 ){
				// 	childGrid.enableRecordButtons(); 
				// }else{
				// 	childGrid.enableRecordButtons(); 
				// }
			}
		});
		
	}

	


});
