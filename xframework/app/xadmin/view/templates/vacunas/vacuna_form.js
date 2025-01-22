x_runJS();

$("#btnGuardar").click(function() {

    x_sendForm($('#f_record'), true, doAddFromWindow, {'modulo': 'vacunas', 'submodulo': 'vacuna_list'});

});

$("#back").click(function() {
    x_goTo('vacunas', 'vacuna_list', '', 'Main', this);
});


