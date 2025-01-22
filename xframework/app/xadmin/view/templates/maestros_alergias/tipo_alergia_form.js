x_runJS();

$("#btnGuardar").click(function() {
    var id = $("#tipoAlergia_idtipoAlergia").val();
    x_sendForm($('#f_record'), true, x_loadModule('maestros_alergias', 'tipo_alergia_list','tipoAlergia_idtipoAlergia=' + id, 'Main'));

});

$("#back").click(function() {
    var id = $("#tipoAlergia_idtipoAlergia").val();
    x_goTo('maestros_alergias', 'tipo_alergia_list', 'tipoAlergia_idtipoAlergia=' + id, 'Main', this);
});


