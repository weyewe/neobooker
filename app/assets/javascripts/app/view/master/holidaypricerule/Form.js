Ext.define('AM.view.master.holidaypricerule.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.holidaypriceruleform',

  title : 'Add / Edit Holiday Price',
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
	        xtype: 'hidden',
	        name : 'id',
	        fieldLabel: 'id'
	      },{
	        xtype: 'textfield',
	        name : 'amount',
	        fieldLabel: 'Harga PerJam'
				},
				{
					xtype: 'datefield',
					name : 'holiday_date',
					fieldLabel: 'Tanggal Libur',
					format: 'Y-m-d',
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
 
});
