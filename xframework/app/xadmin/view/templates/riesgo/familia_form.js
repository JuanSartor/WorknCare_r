x_runJS();


$("#btnGuardar").click(function () {


    x_sendForm($('#f_record'), true, function (data) {
        x_goTo('riesgo', 'familia_form', 'id=' + data.id, 'Main', this);
    });

});


if ($("#idfamilia_riesgo").val() !== "") {
    x_loadModule('riesgo', 'listado_item_familia', 'familia_riesgo_idfamiliariesgo=' + $("#idfamilia_riesgo").val(), 'container_listado_items');
}