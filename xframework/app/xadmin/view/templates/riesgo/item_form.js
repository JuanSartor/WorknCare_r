x_runJS();


$("#btnGuardar").click(function () {


    x_sendForm($('#f_record'), true, function (data) {
        x_goTo('riesgo', 'item_form', 'id=' + data.id, 'Main', this);
    });

});


if ($("#idItemRiesgo").val() !== "") {
    x_loadModule('riesgo', 'listado_check_item', 'item_riesgo_iditemriesgo=' + $("#idItemRiesgo").val(), 'container_listado_check');
}