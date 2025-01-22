x_runJS();

$("#btnGuardar").click(function () {

    x_sendForm($('#f_record'), true, doAddFromWindow, {'modulo': 'maestros_banco', 'submodulo': 'banco_list'});

});

$("#back").click(function () {
    x_goTo('contable', 'reembolsos_list', '', 'Main', this);
});

$("#rechazar").click(function () {
    $("#label_motivo").css("visibility", "visible");
    $("#input_motivo").css("visibility", "visible");
    $("#btn_confimar").css("visibility", "visible");

});

$("#aprobar").click(function () {
    x_sendForm(
            $('#f_record'),
            true,
            function (data) {
                x_alert(data.msg);
                if (data.result) {

                    // aca ingresa sino hay mas registros en estado =0, es decir en curso
                    if (data.idsigrem == 0) {
                        x_goTo('contable', 'reembolsos_list', '', 'Main', this);
                    } else {
                        x_goTo('contable', 'reembolso_form', 'id=' + data.idsigrem, 'Main', this);
                    }
                }
            }
    );
});
$("#confirmar").click(function () {
    x_sendForm(
            $('#f_record'),
            true,
            function (data) {
                x_alert(data.msg);
                if (data.result) {

                    // aca ingresa sino hay mas registros en estado =0, es decir en curso
                    if (data.idsigrem == 0) {
                        x_goTo('contable', 'reembolsos_list', '', 'Main', this);
                    } else {
                        x_goTo('contable', 'reembolso_form', 'id=' + data.idsigrem, 'Main', this);
                    }
                }
            }
    );
});
