Ext.define('AM.view.master.facility.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.facilityform',

  title : 'Add / Edit Facility',
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
	        name : 'title',
	        fieldLabel: ' Nama Fasilitas'
				},
				{
					xtype: 'textarea',
					name : 'description',
					fieldLabel: 'Deskripsi Fasilitas'
				},
				{
					xtype: 'textfield',
					name : 'amount',
					fieldLabel: 'Harga Per Jam'
				},
				{
					xtype: 'numberfield',
					name : 'downpayment_percentage',
					fieldLabel: 'Besar Downpayment (%)'
				},
				
				{
					xtype: 'hidden',
	        name : 'color',
	        fieldLabel: ' Indicator Warna'
				},
				{
					xtype: 'container',
					layout : 'vbox',
					items : [
						{
			        xtype: 'container',
			        html : 'Pilih Indicator Warna',
						},
						
						{
			        xtype: 'customcolorpicker',
			        name : 'color_picker',
			        fieldLabel: ' Indicator Warna'
						},
					]
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

	setColorPickerData: function( record ) {
		// console.log("Inside setColorPickerData");
		// console.log( record ) ;
		var colorId =  record.get("color")
		if(!colorId){
			colorId = 0 ;
		}
		this.down('customcolorpicker').select(colorId);
	}
});
