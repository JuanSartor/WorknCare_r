x_runJS();

$("#btnGuardar").click(function () {

    x_sendForm($('#f_record'), true, function (data) {
        x_goTo('capsulas', 'contenedor_capsula_grupo_form', 'id=' + data.id, 'Main', this);
    });
});
$(".toggle-listado-programas").click(function () {
    let target = $(this).data("target");
    $("#" + target).slideToggle();
});

if ($("#idcontenedorcapsula").val() !== "") {
    x_loadModule('capsulas', 'listado_capsula', 'contenedorcapsula_idcontenedorcapsula=' + $("#idcontenedorcapsula").val(), 'container_listado_capsulas');
}

