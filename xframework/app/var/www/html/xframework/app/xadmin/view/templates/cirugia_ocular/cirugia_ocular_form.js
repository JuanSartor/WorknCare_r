x_runJS();

$("#btnGuardar").click(function() {

    x_sendForm($('#f_record'), true, doAddFromWindow, {'modulo': 'cirugia_ocular', 'submodulo': 'cirugia_ocular_list'});

});

$("#back").click(function() {
    x_goTo('cirugia_ocular', 'cirugia_ocular_list', '', 'Main', this);
});


