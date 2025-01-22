x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_genericos','submodulo':'servicios_medicos_list'});

});

$("#back").click(function() {
    x_goTo('maestros_genericos', 'servicios_medicos_list', '', 'Main', this);
});


