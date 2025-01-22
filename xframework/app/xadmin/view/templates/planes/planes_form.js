x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'planes','submodulo':'planes_list'});

});

$("#back").click(function() {
    x_goTo('planes', 'planes_list', '', 'Main', this);
});


