x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_genericos','submodulo':'titulo_profesional_list'});

});

$("#back").click(function() {
    x_goTo('maestros_genericos', 'titulo_profesional_list', '', 'Main', this);
});


