Ext.define("AM.controller.Authorization", {
	extend : "Ext.app.Controller",
	views : [
		"booking.BookingProcessList",
		'Navigation',
		'BookingProcessPanel'
	],

	 
	
	refs: [
		{
			ref: 'bookingProcessPanel',
			selector: 'bookingProcessPanel'
		} ,
		{
			ref: 'bookingProcessList',
			selector: 'bookingProcessList'
		} ,
		{
			ref : 'userMenu',
			selector : 'navigation #optionsMenu'
		}
	],
	

	 
	init : function( application ) {
		var me = this; 
		 
		me.control({
			"bookingProcessPanel" : {
				activate : this.onActiveProtectedContent
			} 
			
		});
		
	},


	managementFolder : {
		text 			: "Booking", 
		viewClass : '',
		iconCls		: 'text-folder', 
    expanded	: true,
		children 	: [
        
      { 
          text:'Booking', 
          viewClass:'AM.view.booking.Booking', 
          leaf:true, 
          iconCls:'text',
 					conditions : [
						{
							controller : "bookings",
							action  : 'index'
						}
					]
      },
      { 
				text:'Customer', 
				viewClass:'AM.view.booking.Customer', 
				leaf:true, 
				iconCls:'text' ,
				conditions : [
					{
						controller : 'customers',
						action : 'index'
					}
				]
			},
    ]
	},
	
	inventoryFolder : {
		text:'Master Data', 
    viewClass:'Will', 
    iconCls:'text-folder', 
    expanded: true,
		children : [
	
			{ 
				text:'User', 
				viewClass:'AM.view.master.User', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'users',
						action : 'index'
					}
				]
	     },
			{ 
				text:'Facility', 
				viewClass:'AM.view.master.Facility', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'calendars',
						action : 'update_details'
					}
				]
	     },
			{ 
				text:'Holiday Price', 
				viewClass:'AM.view.master.HolidayPriceRule', 
				leaf:true, 
				iconCls:'text',
				conditions : [
					{
						controller : 'calendars',
						action : 'update_details'
					}
				]
	     }
		]
	},
	
	reportFolder : {
		text:'Report', 
    viewClass:'Will', 
    iconCls:'text-folder', 
    expanded: true,
		children : [
			{ 
          text:'Booking', 
          viewClass:'AM.view.report.BookingReport', 
          leaf:true, 
          iconCls:'text' ,
					conditions : [
						{
							controller : 'booking_reports',
							action : 'index'
						}
						
					]
      },
			{ 
          text:'Income', 
          viewClass:'AM.view.report.IncomeReport', 
          leaf:true, 
          iconCls:'text' ,
					conditions : [
						{
							controller : 'incomes',
							action : 'index'
						}
						
					]
      }
		]
		
	},
	
	factoryFolder : {
		text:'Report', 
    viewClass:'Will', 
    iconCls:'text-folder', 
    expanded: true,
		children : [
			{ 
          text:'Penerimaan Bahan Bubut', 
          viewClass:'AM.view.factory.ItemReceival', 
          leaf:true, 
          iconCls:'text' ,
					conditions : [
						{
							controller : 'item_receivals',
							action : 'index'
						}
						
					]
      },
      { 
          text:'Pengerjaan Pabrik', 
          viewClass:'AM.view.factory.TemplateSalesItem', 
          leaf:true, 
          iconCls:'text',
					conditions : [
						{
							controller : 'template_sales_items',
							action : 'index'
						}
					]
      }
		]
		
	},
	
	salesFolder : {
		text:'Sales', 
    viewClass:'Will', 
    iconCls:'text-folder', 
    expanded: true,
		children : [
			{ 
				text:'Customer', 
				viewClass:'AM.view.sales.Customer', 
				leaf:true, 
				iconCls:'text' ,
				conditions : [
					{
						controller : 'customers',
						action : 'index'
					}
				]
			},
			{ 
				text:'Penjualan', 
				viewClass:'AM.view.sales.SalesOrder', 
				leaf:true, 
				iconCls:'text' ,
				conditions : [
					{
						controller : 'sales_orders',
						action : 'index'
					}
				]
			},
			{ 
				text:'Pengiriman', 
				viewClass:'AM.view.sales.Delivery', 
				leaf:true, 
				iconCls:'text' ,
				conditions : [
					{
						controller : 'deliveries',
						action : 'index'
					}
				]
			},
			{ 
				text:'Sales Return', 
				viewClass:'AM.view.sales.SalesReturn', 
				leaf:true, 
				iconCls:'text' ,
				conditions : [
					{
						controller : 'sales_returns',
						action : 'index'
					}
				]
			},
			{ 
				text:'Guarantee Return', 
				viewClass:'AM.view.sales.GuaranteeReturn', 
				leaf:true, 
				iconCls:'text' ,
				conditions : [
					{
						controller : 'guarantee_returns',
						action : 'index'
					}
				]
			}
		]
		
	},
	
	accountingFolder : {
		text:'Accounting', 
    viewClass:'Will', 
    iconCls:'text-folder', 
    expanded: true,
		children : [
			{ 
				text:'Chart of Accounts', 
				viewClass:'AM.view.accounting.ChartOfAccounts', 
				leaf:true, 
				iconCls:'text' ,
				conditions : [
					{
						controller : 'invoices',
						action : 'index'
					}
				]
			},
			{ 
				text:'Posting', 
				viewClass:'AM.view.accounting.TransactionActivity', 
				leaf:true, 
				iconCls:'text' ,
				conditions : [
					{
						controller : 'payments',
						action : 'index'
					}
				]
			}
		]
	},
	
	onActiveProtectedContent: function( panel, options) {
		// console.log("Inside onActiveProtectedContent");
		// console.log("The panel (Authorization)");
		// console.log( panel ) ;
		var me  = this; 
		var currentUser = Ext.decode( localStorage.getItem('currentUser'));
		var email = currentUser['email'];
		// console.log("onActive Protected Content");
		
		// build the navigation tree 
		var processList = panel.down('bookingProcessList');
		processList.setLoading(true);
	
		var treeStore = processList.getStore();
		treeStore.removeAll(); 
		
		// console.log("Gonna build navigation");
		treeStore.setRootNode( this.buildNavigation(currentUser) );
		processList.setLoading(false);
		
		// Update the title of the menu button
		// console.log("Gonna update the user menu");
		var userMenu = me.getUserMenu();

		userMenu.setText( email );
		// console.log("==================>>>>>>>Done with navigation building");
		// console.log("END\n\n");
	},
	
	buildNavigation: function( currentUser ) {
		var me = this; 
		var folderList = [
			this.managementFolder,
			this.inventoryFolder,
			this.reportFolder, 
			this.accountingFolder, 
			// this.paymentFolder 
		];
		
		// console.log("The length of folderList: " + folderList.length );
		var composedFolders = []; 
		for(var i = 0 ; i < folderList.length ; i++){
			var folder = folderList[i];
			
			// console.log("Gonna build the folder");
			var composedFolder = me.buildFolder( currentUser, folder ); 
			if( composedFolder !== null ){
				composedFolders.push( composedFolder );
			}
		}
		
		var data = {
			text : 'text root',
			children : composedFolders
		}
		
		return data; 
	},
	
	buildFolder : function( currentUser, folder ){
		var me = this; 
		// console.log("Inside the build folder");
		var processList = [];
		// console.log("The length of folder['children']: " + folder['children'].length );
		for( var i =0 ; i < folder['children'].length; i++ ){
			var processTemplate = folder['children'][i];
			var process = me.buildProcess( currentUser, processTemplate );
			if( process !== null){
				processList.push( process );
			}
		}
		
		// console.log("The processList length: "   + processList.length);
		// for(var i = 0 ; i < processList.length; i++ ) {
		// 	console.log(processList[i]);
		// }
		
		if( processList.length !== 0 ){
			return {
				text: 			folder['text'], 
				viewClass: 	folder['viewClass'], 
				iconCls: 		folder['iconCls'], 
				expanded: 	folder['expanded'],
				children: 	processList 
			};
		}else{
			return null; 
		}
	},
	
	buildProcess : function(currentUser, processTemplate){
		
		if( !currentUser || !currentUser['role']){
			return null; 
		}
		
		var process = {
			text 			: processTemplate['text'],
			viewClass : processTemplate['viewClass'],
			leaf 			: processTemplate['leaf'],
			iconCls 	: processTemplate['iconCls']
		}
		// console.log("Inside buildProcess");
		// console.log( process );
		
		for( var i =0 ; i < processTemplate['conditions'].length; i++ ){
			var condition = processTemplate['conditions'][i];
			var controller = condition['controller'];
			var action = condition['action'];
			
			if( 
					(
						currentUser['role']['system'] &&
						currentUser['role']['system']['administrator']  
					) || 
					(
							currentUser['role'][controller] && 
							currentUser['role'][controller][action]  
					) ){
				
				// console.log("returning the process");
				return process; 
			}
		}
	 
		// console.log("returning null in the buildProcess");
		return null; 
	}
	
});