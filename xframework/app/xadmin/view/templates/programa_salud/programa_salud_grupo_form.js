x_runJS();

$("#btnGuardar").click(function () {

    x_sendForm($('#f_record'), true, function (data) {
        x_goTo('programa_salud', 'programa_salud_grupo_form', 'id=' + data.id, 'Main', this);
    });
});
$(".toggle-listado-programas").click(function () {
    let target = $(this).data("target");
    $("#" + target).slideToggle();
});
if ($("#idprograma_salud_grupo").val() !== "") {
    x_loadModule('programa_salud', 'listado_programas', 'idprograma_salud_grupo=' + $("#idprograma_salud_grupo").val(), 'container_listado_programas');
}
