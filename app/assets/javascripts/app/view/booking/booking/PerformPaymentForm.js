Ext.define('AM.view.booking.booking.PerformPaymentForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.paybookingform',

  title : 'Pay Booking',
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
					xtype: 'displayfield',
					fieldLabel: 'Sisa Pembayaran',
					name: 'remaining_amount' 
				}
		 
			]
    }];

    this.buttons = [{
      text: 'Pay',
      action: 'pay'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },

	setParentData: function( record ) {
		this.down('form').getForm().findField('customer_name').setValue(record.get('customer_name')); 
		this.down('form').getForm().findField('remaining_amount').setValue(record.get('remaining_amount')); 
	}
});
