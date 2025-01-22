x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'embajador','submodulo':'embajador_list'});

});

$("#back").click(function() {
    x_goTo('embajador', 'embajador_list', '', 'Main', this);
});


