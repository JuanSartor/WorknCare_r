x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_genericos','submodulo':'sector_list'});

});

$("#back").click(function() {
    x_goTo('maestros_genericos', 'sector_list', '', 'Main', this);
});


