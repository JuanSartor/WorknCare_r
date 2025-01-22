x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'programa_salud','submodulo':'cupon_list'});

});

$("#back").click(function() {
    x_goTo('programa_salud', 'cupon_list', '', 'Main', this);
});


