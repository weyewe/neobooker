Ext.define('AM.view.booking.booking.List' ,{
  	extend: 'Ext.grid.Panel',
  	alias : 'widget.bookinglist',

  	store: 'Bookings', 
 

	initComponent: function() {
		this.columns = [
			// { header: 'ID', dataIndex: 'id'},
			// { header: 'Customer',  dataIndex: 'customer_name',  flex: 1 , sortable: false} ,
			{
				xtype : 'templatecolumn',
				text : "Customer",
				flex : 1,
				tpl : 'Name: <b>{customer_name}</b>' + '<br />' + '<br />' +
							'Booking Date:<br /> <b>{booking_datetime}</b>'  
			},
			
			
			{ header: 'Fasilitas',  dataIndex: 'facility_title',  flex: 1 , sortable: false} ,
			{
				xtype : 'templatecolumn',
				text : "Booking",
				flex : 1,
				tpl : 'Start:<br /> <b>{start_datetime}</b>' + '<br />' + '<br />' +
							'Finish:<br /> <b>{end_datetime}</b>'  
			},
			
			{
				xtype : 'templatecolumn',
				text : "Konfirmasi",
				flex : 1,
				tpl : 'Status: <b>{is_confirmed}</b>' + '<br />' + '<br />' +
							'Jumlah: <b>{downpayment_amount}</b>'  
			},
			
			{
				xtype : 'templatecolumn',
				text : "Actual",
				flex : 1,
				tpl : 'Start:<br /> <b>{actual_start_datetime}</b>' + '<br />' + '<br />' +
							'Finish:<br /> <b>{actual_end_datetime}</b>'  
			},
			
			{
				xtype : 'templatecolumn',
				text : "Pembayaran (minus DP)",
				flex : 1,
				tpl : 'Status: <b>{is_paid}</b>' + '<br />' + '<br />' +
							'Jumlah: <b>{remaining_amount}</b>'  
			},
			
			 
	
		];

		this.addObjectButton = new Ext.Button({
			text: 'Add Booking',
			action: 'addObject'
		});

		this.editObjectButton = new Ext.Button({
			text: 'Edit Booking',
			action: 'editObject',
			disabled: true
		});

		this.deleteObjectButton = new Ext.Button({
			text: 'Delete Booking',
			action: 'deleteObject',
			disabled: true
		});
		
		// this.filler = new Ext.toolbar.FillView({});  
		
		this.confirmObjectButton = new Ext.Button({
			text: 'Confirm',
			action: 'confirmObject',
			disabled: true
		});
		this.startObjectButton = new Ext.Button({
			text: 'Mulai',
			action: 'startObject',
			disabled: true
		});
		this.finishObjectButton = new Ext.Button({
			text: 'Selesai',
			action: 'finishObject',
			disabled: true
		});
		
		this.payObjectButton = new Ext.Button({
			text: 'Bayar',
			action: 'payObject',
			disabled: true
		});
		
		this.searchField = new Ext.form.field.Text({
			name: 'searchField',
			hideLabel: true,
			width: 200,
			emptyText : "Search",
			checkChangeBuffer: 300
		}); 




		// this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton, '->', this.searchObjectButton ];
		this.tbar = [this.addObjectButton, this.editObjectButton, this.deleteObjectButton, 
			this.confirmObjectButton, 
			this.startObjectButton,
			this.finishObjectButton,
			this.payObjectButton,
		 this.searchField ];
		
		
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