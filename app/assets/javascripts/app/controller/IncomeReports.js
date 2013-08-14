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
			ref : 'incomeReportPanel',
			selector : 'incomeReport'
		} 
	],

  init: function() {
    this.control({
      'incomeReportPanel': {
        'chartLoaded': this.clearList ,
				'seriesClicked' : this.updateList
      } 
		
    });
  },

	clearList: function(){
		console.log("Gonna clear the list");
	},
	
	updateList: function(){
		console.log("Gonna update the list");
	}



});
