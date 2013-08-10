Ext.define('AM.view.booking.booking.UpdateStartTimeForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.startbookingform',

  title : 'Start Pemakaian Booking',
  layout: 'fit',
	width	: 500,
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
					xtype: 'displayfield',
					fieldLabel: 'Customer',
					name: 'customer_name' 
				},
				{
	        xtype: 'customdatetimefield',
	        name : 'actual_start_datetime',
	        fieldLabel: ' Waktu Mulai Pemakaian',
					dateCfg : {
						format: 'Y-m-d',
					},
					timeCfg : {
						increment : 1 
					}
				}
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
  },

	setParentData: function( record ) {
		this.down('form').getForm().findField('customer_name').setValue(record.get('customer_name')); 
		// this.down('form').getForm().findField('downpayment_amount').setValue(record.get('downpayment_amount')); 
	}
});
