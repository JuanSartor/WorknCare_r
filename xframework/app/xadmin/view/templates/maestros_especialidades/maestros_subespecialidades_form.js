x_runJS();

$("#btnGuardar").click(function() {
    var idespecialidad = $("#especialidad_idespecialidad").val();
    x_sendForm($('#f_record'), true, x_loadModule('maestros_especialidades', 'maestros_subespecialidades_list','especialidad_idespecialidad=' + idespecialidad, 'Main'));

});

$("#back").click(function() {
    var idespecialidad = $("#especialidad_idespecialidad").val();
    x_goTo('maestros_especialidades', 'maestros_subespecialidades_list', 'especialidad_idespecialidad=' + idespecialidad, 'Main', this);
});


