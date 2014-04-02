Ext.define('AM.view.master.holidaypricerule.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.holidaypriceruleform',

  title : 'Add / Edit Price Rule',
  layout: 'fit',
	width	: 800,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
		var me = this; 
		
		this.items = [{
      xtype: 'form',
			msgTarget	: 'side',
			border: false,
      bodyPadding: 10,
			fieldDefaults: {
          labelWidth: 100,
					anchor: '100%'
      },
			height : 350,
			overflowY : 'auto', 
			layout : 'hbox', 
			// height : 400,
			items : [
				me.dayInfo(),
				me.priceInfo()
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
 	
	dayInfo : function(){
		return {
			xtype : 'fieldset',
			title : "Hari",
			flex : 1 , 
			border : true, 
			labelWidth: 30,
			width : '90%',
			defaultType : 'field',
			defaults : {
				anchor : '-10'
			},
			items : [
				{
					fieldLabel : 'Senin',
					name : 'is_monday',
					xtype : 'checkbox'
				}, 
				{
					fieldLabel : 'Selasa',
					name : 'is_tuesday',
					xtype : 'checkbox'
				},
				{
					fieldLabel : 'Rabu',
					name : 'is_wednesday',
					xtype : 'checkbox'
				},
				{
					fieldLabel : 'Kamis',
					name : 'is_thursday',
					xtype : 'checkbox'
				},
				{
					fieldLabel : 'Jumat',
					name : 'is_friday',
					xtype : 'checkbox'
				},
				{
					fieldLabel : 'Sabtu',
					name : 'is_saturday',
					xtype : 'checkbox'
				},
				{
					fieldLabel : 'Minggu',
					name : 'is_sunday',
					xtype : 'checkbox'
				},
			]
		};
	},
	
	priceInfo : function(){
		return  {
			xtype : 'fieldset',
			title : "Harga dan Waktu",
			flex : 1 , 
			border : true, 
			labelWidth: 30,
			width : '90%',
			defaultType : 'field',
			defaults : {
				anchor : '-10'
			},
			items : [
				{
					fieldLabel : 'Jam Mulai (0-23)',
					name : 'hour_start' ,
					xtype: 'numberfield'
				},
				{
					fieldLabel : 'Jam Selesai (0-23)',
					name : 'hour_end' ,
					xtype : 'numberfield'
				},
				{
					fieldLabel : 'Harga per jam',
					name : 'amount' ,
					xtype : 'textfield'
				}
			]
		};
	},

	setColorPickerData: function( record ) {
		var colorId =  record.get("color")
		if(!colorId){
			colorId = 0 ;
		}
		this.down('customcolorpicker').select(colorId);
	}
});
