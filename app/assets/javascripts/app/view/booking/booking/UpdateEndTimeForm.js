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
		var time_field = end_datetime_field.down("timefield");
	
		time_field.setMaxValue("23:59");
		time_field.setMinValue("8:00");
		
		var end_date = record.get("end_datetime").split(" ")[0];
		end_date_field.format = 'Y-m-d';
		end_date_field.setValue(end_date);
		
		var end_hour = record.get("end_datetime").split(" ")[1].split(":")[0];
		var end_min	 = record.get("end_datetime").split(" ")[1].split(":")[1];
		var actual_end_datetime = record.get("actual_end_datetime");
		
		if( actual_end_datetime.length == 0 ){
			time_field.setValue( end_hour + ":" +  end_min.toString() );
		}else{
			var actual_end_hour =  record.get("actual_end_datetime").split(" ")[1].split(":")[0];
			var actual_end_min	 = record.get("actual_end_datetime").split(" ")[1].split(":")[1];
			time_field.setValue( actual_end_hour.toString() + ":" +  actual_end_min.toString() );
		}  
	}
});
