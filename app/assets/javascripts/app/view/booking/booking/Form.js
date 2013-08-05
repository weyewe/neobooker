Ext.define('AM.view.booking.booking.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.bookingform',

  title : 'Add / Edit Booking',
  layout: 'fit',
	width	: 800,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
    this.items = [{
      xtype: 'form',
			msgTarget	: 'side',
			border: false,
      bodyPadding: 10,
			fieldDefaults: {
          labelWidth: 165,
					anchor: '100%'
      },
      items: [
				{
	        xtype: 'hidden',
	        name : 'id',
	        fieldLabel: 'id'
	      },
				{
	        xtype: 'hidden',
	        name : 'calendar_id',
	        fieldLabel: 'Calendar ID'
	      },
	 
				{
	        xtype: 'hidden',
	        name : 'customer_id',
	        fieldLabel: 'Customer ID'
	      },
				{
	        xtype: 'customdatetimefield',
	        name : 'start_datetime',
	        fieldLabel: ' Waktu Mulai',
					dateCfg : {
						format: 'd-m-Y',
					},
					timeCfg : {
						increment : 1 
					}
				},{
					xtype: 'textfield',
					name : 'facility_title',
					fieldLabel: 'Facility Title'
				},{
					xtype: 'textfield',
					name : 'title',
					fieldLabel: 'Judul'
				},
				{
					xtype: 'textfield',
					name : 'customer_name',
					fieldLabel: 'Customer'
				},
				// {
	      // 					xtype: 'textfield',
	      // 					name : 'email',
	      // 					fieldLabel: 'Email'
	      // 				},{
	      // 					xtype: 'textfield',
	      // 					name : 'bbm_pin',
	      // 					fieldLabel: 'PIN BB'
	      // 				},{
	      // 					xtype: 'textarea',
	      // 					name : 'address',
	      // 					fieldLabel: 'Alamat'
	      // 				}
			]
    }];

    this.buttons = [{
      text: 'Save',
      action: 'save'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  }
});
