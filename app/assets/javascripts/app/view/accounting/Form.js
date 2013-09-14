Ext.define('AM.view.account.Form', {
  extend: 'Ext.window.Window',
  alias : 'widget.accountform',

  title : 'Add / Edit Account',
  layout: 'fit',
	width	: 500,
  autoShow: true,  // does it need to be called?
	modal : true, 
// win.show() 
// if autoShow == true.. on instantiation, will automatically be called 
	
	// 
	// self.create_object({
	//     :name => "Cash Drawer",
	//     :parent_id => cash_account.id , 
	//     :account_case => ACCOUNT_CASE[:ledger],
	//     :is_contra_account => false,
	//     :original_account_id => nil,
	//     :code  => APP_SPECIFIC_ACCOUNT_CODE[:cash_drawer]
	//   },true
	//     
	//   )
	// 

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
	      },
	
	
				{
	        xtype: 'hidden',
	        name : 'parent_id',
	        fieldLabel: 'id'
	      },
				{
					// Fieldset in Column 2 - collapsible via checkbox, collapsed by default, contains a panel
					xtype:'fieldset',
					title: 'Account Info', // title or checkboxToggle creates fieldset header  
					layout:'anchor',
					items :[ 
						{
							xtype: 'displayfield',
							fieldLabel: 'Parent Account',
							name: 'parent_name',
							value: '10'
						},
						{
			        xtype: 'textfield',
			        name : 'name',
			        fieldLabel: 'Nama Account'
						},
						{
			        xtype: 'textfield',
			        name : 'account_case',
			        fieldLabel: 'Account Case'
						},
					]
				},
	
				
				
				
				{
					// Fieldset in Column 2 - collapsible via checkbox, collapsed by default, contains a panel
					xtype:'fieldset',
					title: 'Contra Account', // title or checkboxToggle creates fieldset header  
					layout:'anchor',
					items :[
						{
							xtype: 'checkbox',
							name : 'is_contra_account',
							fieldLabel: 'Contra Account?'
						},
						{
							xtype: 'numberfield',
							name : 'original_account_id',
							fieldLabel: 'Normal Account'
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
  } ,

	setParentData: function( record ){
		this.down('form').getForm().findField('parent_name').setValue(record.get('name')); 
		this.down('form').getForm().findField('parent_id').setValue(record.get('id')); 
	},
});
