x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'maestros_os','submodulo':'maestros_os_list'});

});

$("#back").click(function() {
    x_goTo('maestros_os', 'maestros_os_list', '', 'Main', this);
});


