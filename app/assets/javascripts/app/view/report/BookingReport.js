Ext.define('AM.view.report.BookingReport', {
    extend: 'Ext.panel.Panel',
    alias: 'widget.bookingReport',

		layout : {
			type : 'hbox',
			align : 'stretch'
		},
		
		currentFocusDate : new Date(),
		currentViewType : 'week',
	 
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
		
		
		loadStore: function(  ){
			var me = this; 
			var date = me.currentFocusDate; 
			var viewType = me.currentViewType; 
			me.setLoading( true ) ; 
			var viewValue = 0;  // default viewType == week 
			if(viewType === 'month'){
				viewValue = 1;
			}else if( viewType ==='year'){
				viewValue = 2 
			}
			
			me.store1.load({
				params: {
					viewValue : viewValue,
					focusDate :  Ext.Date.format( date, 'Y-m-d H:i:s')
				},
				callback : function(records, options, success){
					me.setLoading(false);
				}
			});
		},
		
		buildSalesChart: function(){
			var me = this; 
			me.store1 = new Ext.data.JsonStore({
			    fields: ['name', 'data1', 'data2', 'data3', 'data4', 'data5', 'data6', 'data7', 'data9', 'data9'],
			    data: me.generateData()
			});
			
			
			// console.log("=======> The generateData()");
			// console.log( me.generateData() );
			me.store1 = Ext.create(Ext.data.JsonStore, {
				storeId : 'role_search',
				fields	: [
					'name',
					'data1'
				],
				proxy  	: {
					type : 'ajax',
					url : 'api/booking_reports',
					reader : {
						type : 'json',
						root : 'records', 
						totalProperty  : 'total'
					}
				},
				autoLoad : false 
			});
			
			// var date = new Date();
			me.loadStore(   );
			
			
			
			
			
			var chart = new Ext.chart.Chart({
	        // width: 800,
	        // height: 400,
					flex : 2 ,
	        animate: true,
	        store: me.store1,
	        shadow: true,
	        axes: [{
	            type: 'Numeric',
	            position: 'left',
	            fields: ['data1'],
	            label: {
	                renderer: Ext.util.Format.numberRenderer('0,0')
	            },
	            title: 'Booking Count (hours)',
	            grid: true,
	            minimum: 0
	        }, {
	            type: 'Category',
	            position: 'bottom',
	            fields: ['name'],
	            title: 'Time'
	        }],
	        series: [{
	            type: 'column',
	            axis: 'bottom',
	            highlight: true,
	            xField: 'name',
	            yField: 'data1',
							tips: {
								trackMouse: true,
								width: 150,
								height: 50,
								renderer: function(storeItem, item) {
									 this.setTitle("Date: " + storeItem.get('name') + '<br />' + 
																	"Hours: "	 + 	storeItem.get('data1'));
								}
							},
	        }],
					
	    });
	
			return chart ; 
		},
		
		thisWeekText : 'Minggu Ini',
		 
		goText : "Go", 
		
		
		jumpToText: "Lihat",
		
		weekText : "Week",
		monthText : "Month",
		yearText : "Year",
		
		buildToolbar: function(){
			this.tbar = {
          cls: 'ext-cal-toolbar',
          border: true,
          items: []
      };

			this.tbar.items.push({
          id: this.id+'-sr-tb-today', text: this.thisWeekText, handler: this.onThisWeekClick, scope: this
      });

			this.tbar.items.push({id: this.id+'-tb-prev', handler: this.onPrevClick, scope: this, iconCls: 'x-tbar-page-prev'});
      this.tbar.items.push({id: this.id+'-tb-next', handler: this.onNextClick, scope: this, iconCls: 'x-tbar-page-next'});
 

			this.tbar.items.push(this.jumpToText);
      this.tbar.items.push({id: this.id+'-tb-jump-dt', xtype: 'datefield', width: 120, showToday: false});
      this.tbar.items.push({id: this.id+'-tb-jump', text: this.goText, handler: this.onJumpClick, scope: this});

			this.tbar.items.push('->');
			
			this.tbar.items.push({
          id: this.id+'-tb-week', text: this.weekText, handler: this.onWeekNavClick, scope: this, toggleGroup: this.id+'-sr-tb-views', pressed : true 
      });

			this.tbar.items.push({
				id: this.id+'-tb-month', text: this.monthText, handler: this.onMonthNavClick, scope: this, toggleGroup: this.id+'-sr-tb-views'
			});

			// this.tbar.items.push({
			//           id: this.id+'-tb-year', text: this.yearText, handler: this.onYearNavClick, scope: this, toggleGroup: this.id+'-sr-tb-views'
			//       });

		 

		},
		
		initComponent: function(){
			var me = this; 
			me.buildToolbar();
	    this.items = [  me.buildSalesChart() ];
	    this.callParent(arguments);
		},
		
		
		
		// Handling the butons 
		// private
    onThisWeekClick: function(){
		// console.log("onThisWeekClick");
			var me = this; 
			me.currentFocusDate = new Date(); 
			me.loadStore();
    },
    
    // private
    onJumpClick: function(){
			// console.log("onJumpClck");
        var dt = Ext.getCmp(this.id+'-tb-jump-dt').getValue();
				var me = this; 
				
				if( dt === null || dt==='') {
					// console.log("THE date is null");
				}else{
					me.currentFocusDate = dt; 
					me.loadStore(); 
				}
				
				

				// console.log( dt ) ;
				// var string = Ext.Date.format( dt, 'Y-m-d H:i:s');
				// console.log("The string");
				// console.log( string );
        // if(dt !== ''){
        //     this.startDate = this.layout.activeItem.moveTo(dt, true);
        //     this.updateNavState();
        //     // TODO: check that view actually changed:
        //     this.fireViewChange();
        // }
    },
    
    // private
    onPrevClick: function(){
			var me = this; 
			if( me.currentViewType === 'week'){
				me.currentFocusDate.setDate( me.currentFocusDate.getDate() - 7 );
			}else if( me.currentViewType ==='month'){
				me.currentFocusDate.setMonth( me.currentFocusDate.getMonth() - 1 );
			}else if( me.currentViewType ==='year'){
				me.currentFocusDate.setYear( me.currentFocusDate.getYear() - 1 );
			}
			me.loadStore() ; 
    },
    
    // private
    onNextClick: function(){
			var me = this; 
			if( me.currentViewType === 'week'){
				me.currentFocusDate.setDate( me.currentFocusDate.getDate() + 7 );
			}else if( me.currentViewType ==='month'){
				me.currentFocusDate.setMonth( me.currentFocusDate.getMonth() + 1 );
			}else if( me.currentViewType ==='year'){
				me.currentFocusDate.setYear( me.currentFocusDate.getYear() + 1 );
			}
      
			me.loadStore() ;
    },
    
    // private
    onWeekNavClick: function(){
			var me = this; 
        // this.setActiveView(this.id+'-day');
			if( me.currentViewType !== 'week'){
				me.currentViewType = 'week';
				me.loadStore();
			}
    },

		// private
    onMonthNavClick: function(){
			var me = this; 
        // this.setActiveView(this.id+'-day');
			if( me.currentViewType !== 'month'){
				me.currentViewType = 'month';
				me.loadStore();
			}
    },

		// private
    onYearNavClick: function(){
			var me = this; 
        // this.setActiveView(this.id+'-day');
			if( me.currentViewType !== 'year'){
				me.currentViewType = 'year';
				me.loadStore();
			}
    },

});
