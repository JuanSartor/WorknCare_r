x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_genericos','submodulo':'laboratorio_list'});

});

$("#back").click(function() {
    x_goTo('maestros_genericos', 'laboratorio_list', '', 'Main', this);
});


