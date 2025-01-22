x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'configuracion','submodulo':'packSMSMedico_list'});

});

$("#back").click(function() {
    x_goTo('configuracion', 'packSMSMedico_list', '', 'Main', this);
});


