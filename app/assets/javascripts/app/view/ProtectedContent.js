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
						html : "Congrats, you are inside. Wanna play around?",
						height: '50px'
						// flex : 1 
        },
        
				{
					xtype : 'navigation',
					// flex : 1
				},
				
				{
					xtype : 'content',
					flex :  1
				}
 					//        {
 					// xtype: 'button',
 					// text: 'Logout',
 					// action: 'logoutUser'  
 					//            
 					//         }
    ]
});
