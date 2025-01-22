x_runJS();

$("#btnGuardar").click(function () {

    x_sendForm($('#f_record'), true, function (data) {
        x_goTo('cuestionarios', 'familia_cuestionario_grupo_form', 'id=' + data.id, 'Main', this);
    });
});
$(".toggle-listado-programas").click(function () {
    let target = $(this).data("target");
    $("#" + target).slideToggle();
});

if ($("#id_familia_cuestionarios").val() !== "") {
    x_loadModule('cuestionarios', 'listado_cuestionarios', 'id_familia_cuestionarios=' + $("#id_familia_cuestionarios").val(), 'container_listado_cuestionarios');
}

