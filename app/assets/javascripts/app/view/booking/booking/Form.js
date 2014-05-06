Ext.define('AM.view.booking.booking.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.bookingform',

  title : 'Add / Edit Booking',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
  initComponent: function() {
	
		var remoteJsonStoreFacility = Ext.create(Ext.data.JsonStore, {
			storeId : 'facility_search',
			fields	: [
	 				{
						name : 'facility_title',
						mapping : "title"
					},
					{
						name : 'facility_id',
						mapping : 'id'
					}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_facilities',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
		
		var remoteJsonStoreCustomer = Ext.create(Ext.data.JsonStore, {
			storeId : 'customer_search',
			fields	: [
			 				{
						name : 'customer_name',
						mapping : "name"
					},
					{
						name : 'customer_bb_pin',
						mapping : 'bb_pin'
					},
					{
						name : 'customer_id',
						mapping : 'id'
					}
			],
			proxy  	: {
				type : 'ajax',
				url : 'api/search_customers',
				reader : {
					type : 'json',
					root : 'records', 
					totalProperty  : 'total'
				}
			},
			autoLoad : false 
		});
		
		
		
		var formItems = [
			{
        xtype: 'hidden',
        name : 'id',
        fieldLabel: 'id'
      },
			{
				fieldLabel: 'Facility',
				xtype: 'combo',
				queryMode: 'remote',
				forceSelection: true, 
				displayField : 'facility_title',
				valueField : 'facility_id',
				pageSize : 5,
				minChars : 1, 
				allowBlank : false, 
				triggerAction: 'all',
				store : remoteJsonStoreFacility , 
				listConfig : {
					getInnerTpl: function(){
						return  	'<div data-qtip="{facility_title}">' +  
												'<div class="combo-name">{facility_title}</div>' +  
						 					'</div>';
					}
				},
				name : 'calendar_id' 
			},
 
			{
				fieldLabel: 'Customer',
				xtype: 'combo',
				queryMode: 'remote',
				forceSelection: true, 
				displayField : 'customer_name',
				valueField : 'customer_id',
				pageSize : 5,
				minChars : 1, 
				allowBlank : false, 
				triggerAction: 'all',
				store : remoteJsonStoreCustomer , 
				listConfig : {
					getInnerTpl: function(){
						return  	'<div data-qtip="{customer_name}">' +  
												'<div class="combo-name">{customer_name}</div>' +  
												'<div class="combo-name">{customer_bb_pin}</div>' +  
						 					'</div>';
					}
				},
				name : 'customer_id' 
			},
			{
        xtype: 'customdatetimefield',
        name : 'start_datetime',
        fieldLabel: ' Waktu Mulai',
				dateCfg : {
					format: 'Y-m-d'
				},
				timeCfg : {
					increment : 60,
					maxValue: "23:59",
					minValue: "08:00"
				}
			},
			{
				xtype: 'numberfield',
				fieldLabel: 'Durasi (jam)',
				name: 'number_of_hours',
				minValue: 1,
				value : 1 
			},
			{
				fieldLabel : 'Wajib Downpayment',
				name : 'is_downpayment_imposed',
				xtype : 'checkbox'
			},
		];
		
		
		var discountFieldConfig = {
			xtype: 'numberfield',
			fieldLabel: 'Diskon (%)',
			name: 'discount',
			minValue: 0,
			maxValue : 100,
			value : 0 
		};
		
		var hiddenDiscountFieldConfig = {
			xtype: 'hidden',
			fieldLabel: 'Discount',
			name: 'discount',
			value : 0 
		};
		
		
		var currentUser = Ext.decode( localStorage.getItem('currentUser'));
		if( 
				(
					currentUser['role']['system'] &&
					currentUser['role']['system']['administrator']  
				) || 
				(
						currentUser['role']['bookings'] && 
						currentUser['role']['bookings']['add_discount']  
				) ){
			
			formItems.push( discountFieldConfig );
		}else{
			formItems.push( hiddenDiscountFieldConfig );
		}
		
		
    this.items = [{
      xtype: 'form',
			msgTarget	: 'side',
			border: false,
      bodyPadding: 10,
			fieldDefaults: {
          labelWidth: 165,
					anchor: '100%'
      },
      items: formItems
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

	setSelectedCustomer: function( customer_id ){
		var comboBox = this.down('form').getForm().findField('customer_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : customer_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( customer_id );
			}
		});
	},
	
	setSelectedCalendar: function( calendar_id ){
		var comboBox = this.down('form').getForm().findField('calendar_id'); 
		var me = this; 
		var store = comboBox.store; 
		store.load({
			params: {
				selected_id : calendar_id 
			},
			callback : function(records, options, success){
				me.setLoading(false);
				comboBox.setValue( calendar_id );
			}
		});
	},


	setComboBoxData : function( record){
		var me = this; 
		me.setLoading(true);
		
		
		me.setSelectedCustomer( record.get("customer_id")  ) ;
		me.setSelectedCalendar( record.get("calendar_id")  ) ;
	}
	
	
});
