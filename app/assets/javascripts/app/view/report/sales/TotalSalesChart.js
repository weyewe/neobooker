Ext.define('AM.view.report.sales.TotalSalesChart', {
    extend: 'Ext.chart.Chart',
// extend : 'Ext.Container'
    alias: 'widget.totalSalesChart',
	 
		generateData: function(n){
		    var data = [],
		        p = (Math.random() *  11) + 1,
		        i;
		    for (i = 0; i < (n || 12); i++) {
		        data.push({
		            name: Ext.Date.monthNames[i],
		            data1: Math.floor(Math.max((Math.random() * 100), 20)),
		            data2: Math.floor(Math.max((Math.random() * 100), 20)),
		            data3: Math.floor(Math.max((Math.random() * 100), 20)),
		            data4: Math.floor(Math.max((Math.random() * 100), 20)),
		            data5: Math.floor(Math.max((Math.random() * 100), 20)),
		            data6: Math.floor(Math.max((Math.random() * 100), 20)),
		            data7: Math.floor(Math.max((Math.random() * 100), 20)),
		            data8: Math.floor(Math.max((Math.random() * 100), 20)),
		            data9: Math.floor(Math.max((Math.random() * 100), 20))
		        });
		    }
		    return data;
		},
		
		initComponent: function() {
			var chart;
	    // 
	    // Ext.get('reloadData').on('click', function() {
	    //     
	    // });
	
		 
			// store1.loadData(generateData());
			var me = this; 
			
			var the_data = me.generateData();
			console.log("The_data:  ");
			console.log( the_data ); 
			
			// var store1 = new Ext.data.JsonStore({
			//     fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data9', 'data9'],
			//     data: me.generateData()
			// });
			// console.log("the first store1 : " ) ;
			// console.log( store1  );
			// 
			// var store1 = Ext.create(Ext.data.JsonStore, {
			// 	storeId : 'role_search',
			// 	fields	: [
			// 		 				{
			// 				name : 'role_name',
			// 				mapping : "name"
			// 			},
			// 			{
			// 				name : 'role_id',
			// 				mapping : 'id'
			// 			}
			// 	],
			// 	proxy  	: {
			// 		type : 'ajax',
			// 		url : 'api/search_role',
			// 		reader : {
			// 			type : 'json',
			// 			root : 'records', 
			// 			totalProperty  : 'total'
			// 		}
			// 	},
			// 	autoLoad : false 
			// });
			// console.log("The second store1");
			// console.log( store1 ) ;
			//  
			
	    			
	    chart = new Ext.chart.Chart({
	        width: 800,
	        height: 600,
	        animate: true,
	        store: store1,
	        shadow: true,
	        axes: [{
	            type: 'Numeric',
	            position: 'left',
	            fields: ['data1'],
	            label: {
	                renderer: Ext.util.Format.numberRenderer('0,0')
	            },
	            title: 'Number of Hits',
	            grid: true,
	            minimum: 0
	        }, {
	            type: 'Category',
	            position: 'bottom',
	            fields: ['name'],
	            title: 'Month of the Year'
	        }],
	        series: [{
	            type: 'column',
	            axis: 'bottom',
	            highlight: true,
	            xField: 'name',
	            yField: 'data1'
	        }]
	    });
	    	
	    		  
	    	
	    this.items = [chart]
	    this.callParent(arguments);
	  },
	
	 
});
