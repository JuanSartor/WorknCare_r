x_runJS();

$("#btnGuardar").click(function () {

    x_sendForm($('#f_record'), true, function (data) {
        x_alert(data.msg);
        if (data.result) {

            x_goTo('programa_salud', 'categoria_form', 'id=' + data.id + "&idprograma_salud=" + $("#programa_salud_idprograma_salud").val(), 'Main', this);
        }
        ;
    });

});

$("#back").click(function () {
    x_goTo('programa_salud', 'programa_salud_form', 'id=' + $("#programa_salud_idprograma_salud").val(), 'Main', this);
});

$(".toggle-listado-medicos").click(function () {
    let target = $(this).data("target");
    $("#" + target).slideToggle();
});

if ($("#idprograma_categoria").val() !== "") {
    x_loadModule('programa_salud', 'listado_medicos_referentes', 'idprograma_categoria=' + $("#idprograma_categoria").val(), 'container_listado_medicos_referentes');
    x_loadModule('programa_salud', 'listado_medicos_complementarios', 'idprograma_categoria=' + $("#idprograma_categoria").val(), 'container_listado_medicos_complementarios');
}
$(".toggle-listado-motivos").click(function () {
    let target = $(this).data("target");
    $("#" + target).slideToggle();
});


