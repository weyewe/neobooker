Ext.define('AM.view.report.income.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.incomeReportList',

  	store: 'Incomes', 
 

	initComponent: function() {
		this.columns = [
			{
				xtype : 'templatecolumn',
				text : "Sumber",
				flex : 1,
				tpl : '<b>{income_source_type}</b>' + '<br />' + '<br />' +
							'Code: <b>{code}</b>'   
			},
			
			 
			{ header: 'Jumlah',  dataIndex: 'amount',  flex: 1 , sortable: false} ,
			{ header: 'Waktu',  dataIndex: 'transaction_datetime',  flex: 1 , sortable: false} 
	
		];

		this.addObjectButton = new Ext.Button({
			text: 'Add Customer',
			action: 'addObject'
		});

		this.editObjectButton = new Ext.Button({
			text: 'Edit Customer',
			action: 'editObject',
			disabled: true
		});

		this.deleteObjectButton = new Ext.Button({
			text: 'Delete Customer',
			action: 'deleteObject',
			disabled: true
		});
		
		// this.filler = new Ext.toolbar.FillView({});  
		
		this.searchField = new Ext.form.field.Text({
			name: 'searchField',
			hideLabel: true,
			width: 200,
			emptyText : "Search",
			checkChangeBuffer: 300
		}); 




		// this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton, '->', this.searchObjectButton ];
		// this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton,  this.searchField ];
		this.bbar = Ext.create("Ext.PagingToolbar", {
			store	: this.store, 
			displayInfo: true,
			displayMsg: 'Displaying income {0} - {1} of {2}',
			emptyMsg: "No income to display" 
		});

		this.callParent(arguments);
	},
 
	loadMask	: true,
		// 
		// getSelectedObject: function() {
		// 	return this.getSelectionModel().getSelection()[0];
		// },
		// 
		// enableRecordButtons: function() {
		// 	this.editObjectButton.enable();
		// 	this.deleteObjectButton.enable();
		// },
		// 
		// disableRecordButtons: function() {
		// 	this.editObjectButton.disable();
		// 	this.deleteObjectButton.disable();
		// }
});