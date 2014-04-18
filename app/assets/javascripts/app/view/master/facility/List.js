Ext.define('AM.view.master.facility.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.facilitylist',

  	store: 'Facilities', 
		allowCRUD: true, 
 

	initComponent: function() {
		this.columns = [
			// { header: 'ID', dataIndex: 'id'},
			{ header: 'Title',  dataIndex: 'title', flex: 1},
			{	header: 'Description', dataIndex: 'description', flex: 1 },
			// {	header: 'Color', dataIndex: 'color', flex: 1 },
			
			// {
			// 	xtype : 'templatecolumn',
			// 	text : "Color",
			// 	flex : 1,
			// 	tpl : '<div class="x-combo-list-item x-cal-{color}' + 
			// 					'<div class="ext-cal-picker-icon">{color}</div>'+ 
			// 				'</div>'
			// },
			
			
			
			


			{	header: 'Sewa Per Jam', dataIndex: 'amount', flex: 1 },
			{	header: '% Downpayment', dataIndex: 'downpayment_percentage', flex: 1 },
		];

		this.addObjectButton = new Ext.Button({
			text: 'Add Facility',
			action: 'addObject'
		});

		this.editObjectButton = new Ext.Button({
			text: 'Edit Facility',
			action: 'editObject',
			disabled: true
		});

		this.deleteObjectButton = new Ext.Button({
			text: 'Delete Facility',
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
		
		
		if(this.allowCRUD === true ){
			
			this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton ];
		}else
		{
			this.tbar = [] 
		}


		
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
		this.editObjectButton.enable();
		this.deleteObjectButton.enable();
	},

	disableRecordButtons: function() {
		this.editObjectButton.disable();
		this.deleteObjectButton.disable();
	}
});
