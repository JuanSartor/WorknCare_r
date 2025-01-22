x_runJS();
x_loadModule('usuarios_empresa', 'facturas_listado', 'idempresa=' + $("#idempresa").val(), 'div_facturas');

$("#btnGuardar").click(function () {

    x_sendForm($('#f_record'), true, function (data) {
        x_alert(data.msg);
        x_loadModule('usuarios_empresa', 'usuarios_form', 'id=' + $("#idempresa").val(), 'Main')
    });

});


//cambiar contraseña, generar y enviar por mail
$("#change_password").click(function () {
    jConfirm(
            "Desea gener una nueva contraseña y enviarla al usuario?",
            "Cambiar contraseña",
            function (r) {
                if (r) {
                    var url = "xadmin.php?";
                    var queryStr = "action=1&modulo=usuarios_empresa&submodulo=edit_password_usuario&idusuario_empresa=" + $("#idusuario_empresa").val();
                    x_doAjaxCall("POST",
                            url,
                            queryStr,
                            function (data) {

                                x_alert(data.msg);
                            },
                            "",
                            "",
                            true,
                            true);
                }
            }
    );
});

/*Accion eliminar suscripcion del Pass bien-être*/
$("#cancelar-suscripcion").click(function () {

    jConfirm(
            "Confirma que desea eliminar la suscripción de la empresa? <br> Se cancelará la facturción en el panel de Stripe.<br> ¡Está acción no puede deshacerse! ",
            "Cancelar suscripción al WorknCare",
            function (r) {
                if (r) {
                    $("body").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'xadmin.php?action=1&modulo=usuarios_empresa&submodulo=cancelar_suscripcion',
                            "idempresa=" + $("#idempresa").val(),
                            function (data) {
                                $("body").spin(false);
                                x_alert(data.msg);
                                x_goTo('usuarios_empresa', 'usuarios_form', 'id=' + $("#idempresa").val(), 'Main', this);
                            }
                    );
                }
            }
    );

});

