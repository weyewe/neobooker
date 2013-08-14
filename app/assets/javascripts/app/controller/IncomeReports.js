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
		console.log("Gonna clear the list");
	},
	
	updateList: function(){
		console.log("Gonna update the list");
	},
	
	onActivePanel: function(){
		console.log("On active Panel");
	},
	onAfterRender: function(){
		console.log("on after render");
	}



});
