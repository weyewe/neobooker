Ext.define('AM.view.master.holidaypricerule.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.holidaypricerulelist',

  	store: 'HolidayPriceRules', 
 

	initComponent: function() {
		this.columns = [
			{
				xtype : 'templatecolumn',
				text : "Tanggal",
				flex : 1,
				tpl : '<b>{holiday_date}</b>'  
			},
			{
				xtype : 'templatecolumn',
				text : "Harga Per Jam",
				flex : 1,
				tpl : '<b>{amount}</b>'  
			},
			
			 
		];
		

		this.addObjectButton = new Ext.Button({
			text: 'Add',
			action: 'addObject',
			disabled : true 
		});
		
	 

		this.editObjectButton = new Ext.Button({
			text: 'Edit',
			action: 'editObject',
			disabled: true
		});
		
		this.deleteObjectButton = new Ext.Button({
			text: 'Delete',
			action: 'deleteObject',
			disabled: true
		});

	 
 



		this.tbar = [this.addObjectButton,  this.editObjectButton, this.deleteObjectButton ];
		// this.bbar = Ext.create("Ext.PagingToolbar", {
		// 	store	: this.store, 
		// 	displayInfo: true,
		// 	displayMsg: 'Displaying topics {0} - {1} of {2}',
		// 	emptyMsg: "No topics to display" 
		// });

		this.callParent(arguments);
	},
 
	loadMask	: true,
	 
	
	getSelectedObject: function() {
		return this.getSelectionModel().getSelection()[0];
	},

	enableRecordButtons: function() {
		this.addObjectButton.enable();
		this.editObjectButton.enable();
		this.deleteObjectButton.enable();
	},

	disableRecordButtons: function() {
		this.addObjectButton.disable();
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
	},
	
	setObjectTitle : function(record){
		this.setTitle("Facility: " + record.get("title"));
	}
});
