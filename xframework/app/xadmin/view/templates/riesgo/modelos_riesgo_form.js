x_runJS();

$("#btnGuardar").click(function () {

    x_sendForm($('#f_record'), true, function (data) {
        x_goTo('riesgo', 'modelos_riesgo_form', 'id=' + data.id, 'Main', this);
    });
});
$(".toggle-listado-programas").click(function () {
    let target = $(this).data("target");
    $("#" + target).slideToggle();
});

if ($("#idmodelos_riesgos").val() !== "") {
    x_loadModule('riesgo', 'listado_familia_form_modelo', 'idmodelos_riesgos=' + $("#idmodelos_riesgos").val(), 'container_listado_cuestionarios');
}

