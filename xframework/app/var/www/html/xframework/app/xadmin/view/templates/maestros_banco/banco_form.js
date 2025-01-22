x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_banco','submodulo':'banco_list'});

});

$("#back").click(function() {
    x_goTo('maestros_banco', 'banco_list', '', 'Main', this);
});


