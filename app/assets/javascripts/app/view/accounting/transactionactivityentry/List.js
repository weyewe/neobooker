Ext.define('AM.view.accounting.transactionactivityentry.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.transactionactivityentrylist',

  	store: 'TransactionActivityEntries', 
 

	initComponent: function() {
		 
		
		this.columns = [
			{
				xtype : 'templatecolumn',
				text : "Case",
				flex : 1,
				tpl : '<b>{entry_case_text}</b>' +   "<br />" + 
							'{account_name}' 
			},
			 
			{	header: 'Amount', dataIndex: 'amount', flex: 1 },
			{	header: 'Bank?', dataIndex: 'is_bank_transaction', flex: 1 },
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
		this.bbar = Ext.create("Ext.PagingToolbar", {
			store	: this.store, 
			displayInfo: true,
			displayMsg: 'Displaying topics {0} - {1} of {2}',
			emptyMsg: "No topics to display" 
		});

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
