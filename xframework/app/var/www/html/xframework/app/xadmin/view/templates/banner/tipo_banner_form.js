x_runJS();

$("#btnGuardar").click(function() {
    x_sendForm($('#f_record'), true, doAddFromWindow, {'modulo': 'banner', 'submodulo': 'tipo_banner_list'});
});

$("#back").click(function() {
    x_goTo('banner', 'tipo_banner_list', '', 'Main', this);
});
