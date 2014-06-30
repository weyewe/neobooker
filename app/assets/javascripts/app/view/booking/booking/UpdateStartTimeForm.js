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
		var start_datetime_field = this.down('form').getForm().findField('actual_start_datetime');
		var start_date_field = start_datetime_field.down("datefield");
		var time_field = start_datetime_field.down("timefield");
	
		
		var start_date = record.get("start_datetime").split(" ")[0];
		start_date_field.format = 'Y-m-d';
		start_date_field.setValue(start_date);
		
		
		// console.log( record.get("start_datetime") );
		var start_hour = record.get("start_datetime").split(" ")[1].split(":")[0];
		var start_min	 = record.get("start_datetime").split(" ")[1].split(":")[1];
		var end_hour   = record.get("end_datetime").split(" ")[1].split(":")[0];
		var end_min    = record.get("end_datetime").split(" ")[1].split(":")[1];
		var actual_start_datetime = record.get("actual_start_datetime");
		// 
		// console.log
		// 
		// end_datetime
		// start_datetime 
		// 
		// minvalue = start_datetime -1
		// maxvalue = end_datetime + 1  << if less than 24 00 

		
		// console.log("Gonna set the min and max value");
		// console.log( time_field );
		// time_field.setMaxValue("12:59");
		// time_field.setMinValue("11:00");
		// time_field.setMaxValue(12.toString() + ":59");
		// time_field.setMinValue(11.toString() + ":00");
		
		time_field.setMaxValue("23:59");
		// time_field.setMinValue("8:00");
		
		time_field.setMinValue("00:00");
		
		// time_field.setMaxValue(end_hour + ":59");
		// time_field.setMinValue(start_hour + ":00");
		
		// time_field.setMaxValue("23:59");
		// time_field.setMinValue("08:00");
		
		// console.log("actual_start_datetime");
		// console.log(actual_start_datetime);
		
		if( actual_start_datetime.length == 0 ){
			// time_field.setValue("17:07");
			time_field.setValue( start_hour + ":" +  start_min.toString() );
		}else{
			var actual_start_hour = record.get("actual_start_datetime").split(" ")[1].split(":")[0];
			var actual_start_min	 = record.get("actual_start_datetime").split(" ")[1].split(":")[1];
			time_field.setValue( actual_start_hour.toString() + ":" +  actual_start_min.toString() );
		}
		
		
		
		
		
		
		// this.down('form').getForm().findField('downpayment_amount').setValue(record.get('downpayment_amount')); 
	}
});
