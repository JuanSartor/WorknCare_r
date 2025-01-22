x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_genericos','submodulo':'tipo_familiar_list'});

});

$("#back").click(function() {
    x_goTo('maestros_genericos', 'tipo_familiar_list', '', 'Main', this);
});


