Ext.define('AM.controller.IncomeReports', {
  extend: 'Ext.app.Controller',

  stores: ['Incomes'],
  models: ['Income'],

  views: [
    'report.IncomeReport',
    'report.income.List',
		'Viewport'
  ],

	refs: [
		{
			ref: 'list',
			selector: 'incomeReportList'
		} ,
		{
			ref: 'viewport',
			selector: 'vp'
		},
		{
			ref : 'incomeReport',
			selector : 'incomeReport'
		} 
	],

  init: function() {
 
	
    this.control({
      'incomeReport': {
        'chartLoaded': this.clearList ,
				'seriesClicked' : this.updateList,
				'activate' : this.onActivePanel,
				'afterrender' : this.onAfterRender
      } 
		
    });
  },

	clearList: function(){
		// console.log("Gonna clear the list");
		// var list = this.getList(); 
		// list.store.loadData([],false);
	},
	
	updateList: function( clickedPoint, viewType  ){
		// console.log("Gonna update the list");
		var list = this.getList(); 
		// console.log( list ) ;
		// var store = list.store;
		// console.log( store) ;
		
		// console.log("Inside the updateList");
		// console.log( arguments );
		// console.log("arguments length: " + arguments.length );
		// for( var i =0 ; i< arguments.length; i++){
		// 	console.log("i value is " + i );
		// 	console.log( arguments[i]);
		// }
		
		// console.log( "The clicked point: "  );
		// console.log( clickedPoint);
		// console.log("The clickedPoint[0]: " + clickedPoint.value[0]);
		// console.log("The clickedPoint[1]: " + clickedPoint.value[1]);
		// 
		// 
		// console.log("\nThe viewType: " ) ;
		// console.log( viewType );
		var selectedDateArray = clickedPoint.value[0].split('/');
		var selectedDate = new Date(
				selectedDateArray[0],
				selectedDateArray[1]-1, // in javascript, month starts from 0
				selectedDateArray[2]
			);
		
		var viewValue = 0;
		if( viewType === 'month'){
			viewValue = 1;
		}
		
		// console.log("The clickedDateValue: " );
		// console.log( clickedPoint.value[0] );
		// console.log("The selectedDate: " );
		// console.log( selectedDate);
		// console.log("The viewValue");
		// console.log( viewValue ) ;
		
		var viewport = this.getViewport();
		viewport.setLoading(true);
		list.store.load({
			params: {
				viewValue : viewValue,
				focusDate :  Ext.Date.format( selectedDate, 'Y-m-d H:i:s')
			},
			callback : function(records, options, success){
				viewport.setLoading(false);
			}
		});
	},
	
	onActivePanel: function(){
		// console.log("On active Panel");
	},
	onAfterRender: function(){
		// console.log("on after render");
	}



});
