x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_alergias','submodulo':'alergia_list'});

});

$("#back").click(function() {
    x_goTo('maestros_alergias', 'alergia_list', '', 'Main', this);
});


