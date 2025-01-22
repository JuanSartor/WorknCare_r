x_runJS();

$("#btnGuardar").click(function () {

    x_sendForm($('#f_record'), true, doAddFromWindow, {'modulo': 'maestros_especialidades', 'submodulo': 'maestros_especialidades_list'});

});

$("#back").click(function () {
    x_goTo('maestros_especialidades', 'maestros_especialidades_list', '', 'Main', this);
});

$(".toggle-listado-motivos").click(function () {
    let target = $(this).data("target");
    $("#" + target).slideToggle();
});


