x_runJS();

$("#btnGuardar").click(function () {

    x_sendForm($('#f_record'), true, function (data) {
        x_goTo('capsulas', 'familia_capsula_grupo_form', 'id=' + data.id, 'Main', this);
    });
});
$(".toggle-listado-programas").click(function () {
    let target = $(this).data("target");
    $("#" + target).slideToggle();
});

if ($("#id_familia_capsula").val() !== "") {
    x_loadModule('capsulas', 'listado_contenedores_capsula', 'id_familia_capsula=' + $("#id_familia_capsula").val(), 'container_listado_contenedores_capsulas');
}

