x_runJS();

$("#btnGuardar").click(function () {

    x_sendForm($('#f_record'), true, function (data) {
        x_goTo('programa_salud_grupo_empresa', 'programa_salud_grupo_empresa_form', 'id=' + data.id, 'Main', this);
    });
});
$(".toggle-listado-programas-empresa").click(function () {
    let target = $(this).data("target");
    $("#" + target).slideToggle();
});
if ($("#idprograma_salud_grupo_empresa").val() !== "") {
    x_loadModule('programa_salud_grupo_empresa', 'listado_programas_empresa', 'idprograma_salud_grupo_empresa=' + $("#idprograma_salud_grupo_empresa").val(), 'container_listado_programas_empresa');
}
