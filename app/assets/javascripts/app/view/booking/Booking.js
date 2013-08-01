Ext.define('AM.view.booking.Booking', {
    extend: 'AM.view.Worksheet',
    alias: 'widget.bookingProcess',
	 
		
		items : [
			{
				xtype : 'bookinglist' ,
				flex : 1 
			} 
		]
});