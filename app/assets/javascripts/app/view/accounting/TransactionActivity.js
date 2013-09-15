Ext.define('AM.view.accounting.TransactionActivity', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.transactionactivityProcess',
	 
		
		
		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		
		items : [
			{
				xtype : 'transactionactivitylist' ,
				flex : 1  
			},
			{
				xtype :'transactionactivityentrylist',
				// xtype : 'container',
				flex : 1,
				// html : "Awesome result"
			} 
		],
		
		selectedObject : null, 
		selectedChild : null 
});