Ext.define('AM.view.ProtectedContent', {
    extend: 'Ext.panel.Panel',
		alias : 'widget.protectedcontent',
    
    
		layout : {
			type : 'vbox',
			align : 'stretch'
		},
    
    items: [
        {
            xtype : 'container',
						html : "Congrats, you are inside. Wanna play around?"
        },
        
				{
					xtype : 'navigation'
				},
				
				{
					xtype : 'content'
				}
 					//        {
 					// xtype: 'button',
 					// text: 'Logout',
 					// action: 'logoutUser'  
 					//            
 					//         }
    ]
});
