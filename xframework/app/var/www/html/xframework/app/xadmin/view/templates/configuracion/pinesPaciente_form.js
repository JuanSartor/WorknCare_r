x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'configuracion','submodulo':'pinesPaciente_list'});

});

$("#back").click(function() {
    x_goTo('configuracion', 'pinesPaciente_list', '', 'Main', this);
});


