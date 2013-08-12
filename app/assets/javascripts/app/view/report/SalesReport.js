Ext.define('AM.view.report.SalesReport', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.salesReport',
	 
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
		
		initComponent: function(){
			var me = this; 
			
			var store1 = new Ext.data.JsonStore({
			    fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data9', 'data9'],
			    data: me.generateData()
			});
			
			
			var chart = new Ext.chart.Chart({
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
	            title: 'Sales ( Report )',
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
		
		// items : [
		// 	{
		// 		xtype : 'totalSalesChart' ,
		// 		flex : 1  
		// 	} ,
		// 	// {
		// 	// 	xtype : 'container',
		// 	// 	flex : 1 , 
		// 	// 	html : "This is the container"
		// 	// }
		// ]
});