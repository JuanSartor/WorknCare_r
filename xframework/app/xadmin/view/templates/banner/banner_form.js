x_runJS();

$("#btnGuardar").click(function() {
    x_sendForm($('#f_record'), true, doAddFromWindow, {'modulo': 'banner', 'submodulo': 'banner_list'});
});

$("#back").click(function() {
    x_goTo('banner', 'banner_list', '', 'Main', this);
});
