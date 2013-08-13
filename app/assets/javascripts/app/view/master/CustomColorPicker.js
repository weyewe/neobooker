Ext.define('AM.view.master.CustomColorPicker', {
    extend: 'Extensible.calendar.util.ColorPicker',
    mixins: {
        field: 'Ext.form.field.Field'
    },
    alias: 'widget.customcolorpicker',
     
		requires: ['Ext.XTemplate'],
    
    // private
    colorCount: 32,

		// private
    handleClick : function(e, t){
		// console.log("YEAH BUUDDDY, we are in");
		// console.log("The e: " ) ;
		// console.log( e ) ;
		// console.log("\n The t:");
		// console.log( t  );
		
		e.preventDefault();
    
    var colorId = t.className.split('x-cal-')[1];

		// console.log("The colorID");
		// console.log( colorId);
			this.fireEvent('colorSelected', colorId, this );
			this.select(colorId);
        // e.preventDefault();
        // 
        // var colorId = t.className.split('x-cal-')[1];
        // this.select(colorId);
    },
});