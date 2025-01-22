x_runJS();

$("#btnGuardar").click(function() {
    var id = $("#enfermedad_idenfermedad").val();
    x_sendForm($('#f_record'), true, x_loadModule('maestros_enfermedades', 'tipo_enfermedad_list','enfermedad_idenfermedad=' + id, 'Main'));

});

$("#back").click(function() {
    var id = $("#enfermedad_idenfermedad").val();
    x_goTo('maestros_enfermedades', 'tipo_enfermedad_list', 'enfermedad_idenfermedad=' + id, 'Main', this);
});


