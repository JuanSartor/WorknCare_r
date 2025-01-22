x_runJS();

var alert_resultado = function (data) {
    $("body").spin(false);
    if (data.result) {

        // Si el sistema me devuelve que tengo toda la info primcipal y requerida completa evaluo si recargo o no la pantalla.
        if (data.reload_info_profesional == 1) {

            // Si antes estaba la alerta, lo que hago es removerla
            if ($("#info_profesional p.span_alert").length > 0) {
                $("#info_profesional p.span_alert").hide();
            }
        }
        x_alert(data.msg, function () {
            $('html, body').animate({
                scrollTop: $("#div_menu_usuario").offset().top - 200}, 1000);
        });
        x_loadModule('usuario', 'menu_usuario', 'sm=datos_info_profesionales', 'div_menu_usuario');
    } else {
        x_alert(data.msg);
    }

};

/**
 * validamos la composicion del numero AM ingresado por el médico
 * @param {type} numero_am
 * @returns {Boolean}
 */
var validar_numero_am = function (numero_am) {

    if (numero_am.length != 9) {
        return false;
    }

    return true;

};


$(document).ready(function () {

    //modal Solicitud modificacion datos
    $("#btnSolicitudModificacion").click(function () {
        $("#modal-solicitud-modificacion-datos").modal("toggle");
    });

    $("#btnEnviarSolicitudModificacion").click(function () {
        if ($("#f_solicitud textarea").val().length == 0) {
            x_alert(x_translate("Ingrese el texto de la solicitud"));
            return false;
        }
        $("#Main").spin("large");

        x_sendForm(
                $('#f_solicitud'),
                true,
                function (data) {
                    $("#Main").spin(false);
                    x_alert(data.msg);

                    if (data.result) {
                        $("#f_solicitud textarea").val("");
                        $("#modal-solicitud-modificacion-datos").modal("hide");
                    }

                }
        );
    });


    $("#numero_am").mask('000000000');
    //$("#numero_adeli").mask('00000000000');

    $('#numero_adeli').keyup(function () {
        this.value = this.value.toUpperCase();
    });

//select al cambiar modod facturacion, muestro distintos mensajes
    $("#facturacion_teleconsulta").change(function () {

        //mostramos el mensaje de facturacion a la caja
        if ($("#facturacion_teleconsulta").val() == 1) {
            $("#p_teletransmision_caja").show();

        } else {
            $("#p_teletransmision_caja").hide();
        }
        //mostramos el mensaje de envio por el paciente
        if ($("#facturacion_teleconsulta").val() == 2) {
            $("#p_envio_paciente").show();

        } else {
            $("#p_envio_paciente").hide();
        }
    });
    $("#btnGuardarInfoPersonal").click(function () {
        if ($("#pais_idpais").val() == 1) {

            if ($("#tipo_especialidad").val() == 1) {
                if ($("#numero_am").length === 1) {
                    if ($("#numero_am").val() == "" || !validar_numero_am($("#numero_am").val())) {
                        $("#numero_am").data("title", x_translate("Ingrese un número AM válido")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#numero_am").offset().top - 200}, 1000);
                        return false;
                    }
                }
                if ($("#facturacion_teleconsulta").length === 1) {
                    if ($("#facturacion_teleconsulta").val() == "") {
                        $("#facturacion_teleconsulta").data("title", x_translate("Seleccion una facturación de teleconsulta")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#facturacion_teleconsulta").offset().top - 200}, 1000);
                        return false;
                    }
                }


            }
            if ($("#sector_idsector").length === 1) {
                if ($("#sector_idsector").val() == "") {
                    $("#sector_idsector").data("title", x_translate("Seleccione un sector")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#sector_idsector").offset().top - 200}, 1000);
                    return false;
                }
            }
        }
        $("body").spin(false);
        x_sendForm($('#frm_medico'), true, alert_resultado);
    });

});

