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
		
		var list = this.getList(); 
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
		
		var viewport = this.getViewport();
		viewport.setLoading(true);
		
		list.getStore().getProxy().extraParams.viewValue =  viewValue ;
		list.getStore().getProxy().extraParams.focusDate =  Ext.Date.format( selectedDate, 'Y-m-d H:i:s') ;
		list.getStore().load({
			callback : function(records, options, success){
				viewport.setLoading(false);
			}
		});
		
		// 
		// list.store.load({
		// 	params: {
		// 		viewValue : viewValue,
		// 		focusDate :  Ext.Date.format( selectedDate, 'Y-m-d H:i:s')
		// 	},
			// callback : function(records, options, success){
			// 	viewport.setLoading(false);
			// }
		// });
	},
	
	onActivePanel: function(){
		// console.log("On active Panel");
	},
	onAfterRender: function(){
		// console.log("on after render");
		this.getList().getStore().loadData([],false);
	}



});
