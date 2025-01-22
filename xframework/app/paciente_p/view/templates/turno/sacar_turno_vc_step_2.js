
$(document).ready(function () {

    $("#Main").spin(false);
    renderUI2();
    scrollToEl($("body"));
    $(".ce-nc-steps li.ce-nc-step").eq(1).addClass("actual");

    $("#btn_back").click(function () {
        $("#Main").spin("large");
        x_loadModule('turno', 'sacar_turno_vc_step_1', 'turno=' + $("#idturno").val(), 'Main', BASE_PATH + "paciente_p");
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
        x_loadModule('turno', 'sacar_turno_vc_step_3', 'turno=' + $("#idturno").val(), 'Main', BASE_PATH + "paciente_p");
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
                    }
                }
        );
    });
});