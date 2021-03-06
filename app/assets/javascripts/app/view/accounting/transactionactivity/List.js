Ext.define('AM.view.accounting.transactionactivity.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.transactionactivitylist',

  	store: 'TransactionActivities', 
 

	initComponent: function() {
		this.columns = [
		 	{
				xtype : 'templatecolumn',
				text : "Deskripsi",
				flex : 1,
				tpl : '<b>{transaction_source_type}</b>'  + '<br />'  +
							'{description}'    
			},
			{	header: 'Jumlah', dataIndex: 'amount', flex: 1 },
			{	header: 'Tanggal', dataIndex: 'transaction_datetime', flex: 1 },
			{	header: 'Konfirmasi', dataIndex: 'is_confirmed', flex: 1 },
		];

		this.addObjectButton = new Ext.Button({
			text: 'Add',
			action: 'addObject'
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
		
		this.searchField = new Ext.form.field.Text({
			name: 'searchField',
			hideLabel: true,
			width: 200,
			emptyText : "Search",
			checkChangeBuffer: 300
		});
		
		this.confirmObjectButton = new Ext.Button({
			text: 'Confirm',
			action: 'confirmObject',
			disabled: true
		});
		
		this.unconfirmObjectButton = new Ext.Button({
			text: 'Unconfirm',
			action: 'unconfirmObject',
			disabled: true
		});
		
		this.searchField = new Ext.form.field.Text({
			name: 'searchField',
			hideLabel: true,
			width: 200,
			emptyText : "Search",
			checkChangeBuffer: 300
		});



		this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton, 
											this.confirmObjectButton , this.unconfirmObjectButton, '->', this.searchField ];
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

	enableRecordButtons: function(record) {
		var value = record.get("is_confirmed");
		// console.log("The value");
		// console.log( value ) ;
		if( record.get("is_confirmed") === false ){
			this.confirmObjectButton.enable();
			this.unconfirmObjectButton.disable();
		}else{
			this.confirmObjectButton.disable();
			this.unconfirmObjectButton.enable();
		}
		
		this.editObjectButton.enable();
		this.deleteObjectButton.enable();
		
		
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
		this.confirmObjectButton.disable();
		this.unconfirmObjectButton.disable();
	}
});
