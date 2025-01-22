
$(document).ready(function () {
    scrollToEl($("body"));
    $(".ce-nc-steps li.ce-nc-step").removeClass("actual");
    $(".ce-nc-steps li.ce-nc-step").eq(1).addClass("actual");
    // Inicialización de los checks
    $(':checkbox').radiocheck();

    $("#beneficia_reintegro").on('change.radiocheck', function () {
        if ($("#beneficia_reintegro").is(":checked")) {
            $("#div_reintegro_checked").show();
            $("#div_reintegro_unchecked").hide();

            //si hay 2 tarifas la intercambiamos
            if ($("#div_tarifa_original").length > 0) {
                $("#div_tarifa_reintegro").show();
                $("#div_tarifa_original").hide();
            }
        } else {
            $("#div_reintegro_checked").hide();
            $("#div_reintegro_unchecked").show();
            //si hay 2 tarifas la intercambiamos
            if ($("#div_tarifa_original").length > 0) {
                $("#div_tarifa_reintegro").hide();
                $("#div_tarifa_original").show();
            }
        }
    });

    $("#cancelar_pago").click(function () {
        $("#Main").spin("large");
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'cancelar_from_creacion.do',
                'id=' + $("#idturno").val(),
                function (data) {
                    $("#Main").spin(false);
                    if (data.result) {
                        window.location.href = BASE_PATH + "panel-paciente/";
                    } else {
                        x_alert(data.msg);
                    }
                }
        );
    });

    $("#btnConfirmarDebitoPlan").click(function () {
        $("#Main").spin("large");
        if ($("#beneficia_reintegro").is(":checked")) {
            var reintegro = 1;
        } else {
            var reintegro = 0;
        }
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'confirmar_pago_turno.do',
                'idturno=' + $("#idturno").val() + "&beneficia_reintegro=" + reintegro,
                function (data) {
                    $("#Main").spin(false);
                    if (data.result) {
                        $("#div_confirmacion_pago").hide();
                        $("#div_turno_reservado").show();
                    } else {
                        x_alert(data.msg);
                    }
                }
        );
    });




    $("#btnEnviarComentario").click(function () {

        if ($("#txt_comentario").val() === "") {
            x_alert(x_Translate("Ingrese en texto del comentario"));
            return false;
        }
        $("#Main").spin("large");
        x_sendForm(
                $('#f_comentario'),
                true,
                function (data) {
                    $("#Main").spin(false);
                    if (data.result) {
                        $("#comentario_send").html($("#txt_comentario").val());
                        $("#div_comentario").html("");
                        x_alert(x_translate("Se envió el comentario correctamente. Gracias por utilizar nuestros servicios"),
                                function () {
                                    recargar(BASE_PATH + "panel-paciente/home.html");
                                })
                        $("#comentario_send").parent().slideDown();
                    } else {
                        x_alert(x_translate("Se produjo un error al enviar el comentario. Intente nuevamente"));
                    }
                }
        );
    });

});