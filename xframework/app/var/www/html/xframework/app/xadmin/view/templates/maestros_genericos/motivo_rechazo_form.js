x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_genericos','submodulo':'motivo_rechazo_list'});

});

$("#back").click(function() {
    x_goTo('maestros_genericos', 'motivo_rechazo_list', '', 'Main', this);
});


