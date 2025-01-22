x_runJS();

$("#btnGuardar").click(function(){

	x_sendForm($('#f_record'),true,doAddFromWindow,{'modulo':'tags_medico','submodulo':'tags_list'});

});

$("#back").click(function() {
    x_goTo('tags_medico', 'tags_list', '', 'Main', this);
});


