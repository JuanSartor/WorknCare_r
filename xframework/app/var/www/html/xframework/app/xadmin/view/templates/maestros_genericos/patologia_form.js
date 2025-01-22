x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_genericos','submodulo':'patologia_list'});

});

$("#back").click(function() {
    x_goTo('maestros_genericos', 'patologia_list', '', 'Main', this);
});


