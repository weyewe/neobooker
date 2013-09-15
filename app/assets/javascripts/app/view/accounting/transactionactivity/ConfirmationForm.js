Ext.define('AM.view.accounting.transactionactivity.ConfirmationForm', {
  extend: 'Ext.window.Window',
  alias : 'widget.confirmtransactionactivityform',

  title : 'Confirm Transaction ',
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
					fieldLabel: 'Deskripsi',
					name: 'description' 
				},
				{
					xtype: 'displayfield',
					fieldLabel: 'Tanggal',
					name: 'transaction_datetime' 
				}
		 
			]
    }];

    this.buttons = [{
      text: 'Confirm',
      action: 'confirm'
    }, {
      text: 'Cancel',
      scope: this,
      handler: this.close
    }];

    this.callParent(arguments);
  },

	setParentData: function( record ) {
		this.down('form').getForm().findField('description').setValue(record.get('description')); 
		this.down('form').getForm().findField('transaction_datetime').setValue(record.get('transaction_datetime')); 
	}
});
