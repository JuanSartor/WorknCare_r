
$(document).ready(function () {
    $(".ce-nc-steps li.ce-nc-step").eq(1).addClass("actual");

    $("#Main").spin(false);
    scrollToEl($("body"));
    renderUI2();
    $("#btn_back").click(function () {
        x_loadModule('turno', 'sacar_turno_step_1', 'turno=' + $("#idturno").val(), 'Main', BASE_PATH + "paciente_p");
    });


    $("#generateCodigoCelular").click(function () {
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'generar_codigo_celular.do',
                "",
                function (data) {
                    if (data.result) {
                        x_alert(x_translate("En unos momentos recibiras un SMS con el código de validación de tu celular"));
                    } else {
                        x_alert(data.msg);
                    }

                }
        );
    });

    $("#validarCodigoCelular").click(function () {
        var codigo = $("#codigo").val();
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'validar_codigo_celular.do',
                "codigoValidacionCelular=" + codigo,
                function (data) {
                    if (data.result) {
                        $(".bst-validar-cel").slideUp();
                        $("#codigo").val("");
                    }

                    x_alert(data.msg);
                }
        );
    });

    $("#btn_confirmar").click(function () {
        $("#Main").spin("large");
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'confirmar_turno.do',
                'id=' + $("#idturno").val(),
                function (data) {
                    $("#Main").spin(false);
                    if (data.result) {
                        x_loadModule('turno', 'sacar_turno_step_3', 'turno=' + $("#idturno").val(), 'Main', BASE_PATH + "paciente_p");
                    } else {
                        x_alert(data.msg);
                    }

                }
        );
    });

    $("#btnCancelar").click(function () {
        $("#Main").spin("large");
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'cancelar_from_creacion.do',
                'id=' + $("#idturno").val(),
                function (data) {
                    $("#Main").spin(false);
                    if (data.result) {
                        window.location.href = BASE_PATH + "panel-paciente/busqueda-profesional/";
                    } else {
                        x_alert(data.msg);
                    }
                }
        );
    });
});