Ext.define('AM.view.master.pricerule.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.pricerulelist',

  	store: 'PriceRules', 
 

	initComponent: function() {
		this.columns = [
			{
				xtype : 'templatecolumn',
				text : "Hari Aktif",
				flex : 1,
				tpl : 'Senin: <b>{is_monday}</b>' +   "<br />" + 
							'Selasa: <b>{is_tuesday}</b>' +  "<br />" + 
							'Rabu: <b>{is_wednesday}</b>' +  "<br />" + 
							'Kamis: <b>{is_thursday}</b>' +  "<br />" + 
							'Jumat: <b>{is_friday}</b>' +  "<br />" + 
							'Sabtu: <b>{is_saturday}</b>' +  "<br />" + 
							'Minggu: <b>{is_sunday}</b>'   
			},
			{
				xtype : 'templatecolumn',
				text : "Jam",
				flex : 1,
				tpl : '<b>{hour_start}</b> - <b>{hour_end}</b>'  
			},
			{
				xtype : 'templatecolumn',
				text : "Harga",
				flex : 1,
				tpl : '<b>{amount}</b>'  
			},
			
			{
				xtype : 'templatecolumn',
				text : "Type",
				flex : 1,
				tpl : '<b>{rule_case_name}</b>'  
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
