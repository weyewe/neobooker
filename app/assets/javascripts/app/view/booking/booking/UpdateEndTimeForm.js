Ext.define('AM.view.booking.booking.UpdateEndTimeForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.endbookingform',

  title : 'Selesai Pemakaian Booking',
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
	        name : 'actual_end_datetime',
	        fieldLabel: ' Waktu Selesai Pemakaian',
					dateCfg : {
						format: 'Y-m-d',
						readOnly: true 
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
		
		var end_datetime_field = this.down('form').getForm().findField('actual_end_datetime');
		var end_date_field = end_datetime_field.down("datefield");
	
		
		var end_date = record.get("start_datetime").split(" ")[0];
		end_date_field.format = 'Y-m-d';
		end_date_field.setValue(end_date);
		
		// this.down('form').getForm().findField('downpayment_amount').setValue(record.get('downpayment_amount')); 
	}
});
