x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_enfermedades','submodulo':'enfermedad_list'});

});

$("#back").click(function() {
    x_goTo('maestros_enfermedades', 'enfermedad_list', '', 'Main', this);
});


