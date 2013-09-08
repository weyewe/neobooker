Ext.define('AM.controller.Facilities', {
  extend: 'Ext.app.Controller',

  stores: ['Facilities'],
  models: ['Facility'],

  views: [
    'master.facility.List',
    'master.facility.Form',
		'master.pricerule.List'
  ],

  	refs: [
		{
			ref: 'list',
			selector: 'facilitylist'
		},
		{
			ref : 'priceRuleList',
			selector : 'pricerulelist'
		},
		
		{
			ref : 'form',
			selector : 'facilityform'
		}
	],

  init: function() {
    this.control({
      'facilitylist': {
        itemdblclick: this.editObject,
        selectionchange: this.selectionChange,
				afterrender : this.loadObjectList,
      },
      'facilityform button[action=save]': {
        click: this.updateObject
      },
			'facilityform customcolorpicker' : {
				'colorSelected' : this.onColorPickerSelect
			},

      'facilitylist button[action=addObject]': {
        click: this.addObject
      },
      'facilitylist button[action=editObject]': {
        click: this.editObject
      },
      'facilitylist button[action=deleteObject]': {
        click: this.deleteObject
			}	,
			'facilitylist textfield[name=searchField]': {
				change: this.liveSearch
			}
		
    });
  },

	onColorPickerSelect: function(colorId, theColorPicker){
		var win = theColorPicker.up('window');
    var form = win.down('form');
		var colorField = form.getForm().findField('color'); 
		
		
		// console.log("the colorId in onColorPickerSelect:");
		// console.log( colorId);
		colorField.setValue( colorId );
		
		// console.log("The colorField.getValue()");
		// console.log( colorField.getValue() );
	
	},

	liveSearch : function(grid, newValue, oldValue, options){
		var me = this;

		me.getFacilitiesStore().getProxy().extraParams = {
		    livesearch: newValue
		};
	 
		me.getFacilitiesStore().load();
	},
 

	loadObjectList : function(me){
		// console.log("************* IN THE USERS CONTROLLER: afterRENDER");
		me.getStore().load();
	},

  addObject: function() {
    var view = Ext.widget('facilityform');
    view.show();
  },

  editObject: function() {
    var record = this.getList().getSelectedObject();
    var view = Ext.widget('facilityform');

    view.down('form').loadRecord(record);
		// view.setComboBoxData(record); 
		view.setColorPickerData(record)
  },

  updateObject: function(button) {
    var win = button.up('window');
    var form = win.down('form');
		var me = this; 

    var store = this.getFacilitiesStore();
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
					me.reject();
				}
			});
				
			 
		}else{
			//  no record at all  => gonna create the new one 
			var me  = this; 
			var newObject = new AM.model.Facility( values ) ;
			
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
      var store = this.getFacilitiesStore();
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
		var priceRuleGrid = this.getPriceRuleList();
		// priceRuleGrid.setTitle("Purchase Order: " + record.get('code'));
		priceRuleGrid.setObjectTitle( record ) ;
		priceRuleGrid.getStore().load({
			params : {
				calendar_id : record.get('id')
			},
			callback : function(records, options, success){
				
				var totalObject  = records.length;
				if( totalObject ===  0 ){
					priceRuleGrid.enableRecordButtons(); 
				}else{
					priceRuleGrid.enableRecordButtons(); 
				}
			}
		});
		
	}

	


});
