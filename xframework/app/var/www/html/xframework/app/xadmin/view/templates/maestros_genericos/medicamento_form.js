x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_genericos','submodulo':'medicamento_list'});

});

$("#back").click(function() {
    x_goTo('maestros_genericos', 'medicamento_list', '', 'Main', this);
});


