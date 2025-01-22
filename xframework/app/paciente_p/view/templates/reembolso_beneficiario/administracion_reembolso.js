
$(function () {

    $('#ver-archivo').on('hidden.bs.modal', function () {
        $(this)
                .removeData('bs.modal')
                .find(".modal-content").html('');
    });
// boton del 1er paso para validar el IBAN, es una validacion local 
    $("#validar_iban").click(function () {

        ibanSinEspacios = $("#iban").val().split(/\s/).join('');
        bandera = 0;
        if (ibanSinEspacios.substr(0, 2) == "FR" && ibanSinEspacios.length == 27) {
            bandera = 1;
        } else if (ibanSinEspacios.substr(0, 2) == "LU" && ibanSinEspacios.length == 20) {
            bandera = 1;
        } else if (ibanSinEspacios.substr(0, 2) == "BE" && ibanSinEspacios.length == 16) {
            bandera = 1;
        } else if (ibanSinEspacios.substr(0, 2) == "CH" && ibanSinEspacios.length == 21) {
            bandera = 1;
        } else {
            x_alert(x_translate("Ingrese un código IBAN válido"));
            return false;
            bandera = 0;
        }
        if (bandera == 1) {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + "get_banco_xp_iban.do",
                    'iban=' + ibanSinEspacios,
                    function (data) {

                        //  console.log(data);

                        if (data != '') {
                            $("#section-iban").hide("slow");
                            $("#section-factura").show("slow");
                            $("#ibanForm2").val($("#iban").val());
                        } else {
                            x_alert(x_translate("Ingrese un código IBAN válido"));
                        }
                    }
            );
        }

    });
// boton de paso 2 al clickear valido que exista al menos un archivo cargardo
// y q a su vez no se este cargando ninguno si esto se cumple envio el formulario
    $("#btn-carga-archivos").click(function () {
        if ($(this).data("vc") > 0) {
//carga de imagenes en proceso
            if ($("#dropzone .dz-complete").length !== $("#dropzone .dz-preview").length) {
                x_alert(x_translate("Aguarde mientras se cargan los archivos adjuntos"));
                return false;
            }
// verifico que cargo algun archivo
            else if ($("#dropzone .dz-complete").length < 1) {
                x_alert(x_translate("Debe cargar algun archivo"));
                return false;
            } else {
                x_sendForm($('#form_reembolso_steep-2'), true, function (data) {

                    if (data.result) {
                        $("#form_reembolso_steep-1")[0].reset();
                        $("#section-factura").hide("slow");
                        $("#section-confirmacion").show("slow");
                        $("#Main").spin(false);
                    } else {
                        x_alert(data.msg);
                    }
                });
            }

        } else {
            x_alert(x_translate("No posee disponibilidad para realizar un Reembolso"));
        }
    });

// boton del ultimo paso el cual permite volver a mis reembolsos
    $("#btn-mis-reembolsos-confirmacion").click(function (e) {
        x_loadModule('reembolso_beneficiario', 'administracion_reembolso', '', 'menu-reembolsos-datos', BASE_PATH + "paciente_p").then(function () {
            $("#section-confirmacion").hide("slow");
            $(".container-reembolso").removeClass("container-activo-recibir-reembolso");
            $(".container-mis-reembolsos").addClass("container-activo-mis-reembolso");
            $(".container-datos-mis-reembolsos").show();
            $(".container-datos-bancarios").hide();
        });
    });
// boton para enviar el mail de comentario de un reembolso realizado y rechazado
    $("#btnEnviarComentario").click(function (e) {

        if ($("#textarea").val()) {

            if ($("#banderaEstado").val() == "1") {
                var estado = "Realizado";
            } else {
                var estado = "Rechazado";
            }

// llamo al action para enviar el mail
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + "enviar_mail_soporte.do",
                    'textarea=' + $("#textarea").val() + "&idReembolso=" + $("#idReembolso").val()
                    + "&estado=" + estado,
                    function (data) {


                        if (data != '') {

                            $("#modal_enviar_comentario_soporte").modal("hide");
                            x_alert(x_translate("Mail enviado correctamente"));
                        } else {
                            x_alert(x_translate("No pudo enviarse el mail"));
                        }
                    }
            );
        } else {
            x_alert(x_translate('Debe completar con algun comentario'));
        }
    });
});
/**
 *  los metodos de abajo son los onclick para abrir el modal y setear el id del reembolso
 *  rechazados y realizados
 * 
 * @param {type} a
 * @returns {undefined}
 * 
 */
function reembolsoRechazado(a) {
    $("#modal_enviar_comentario_soporte").modal("show");
    $("#idReembolso").val(a);
    $("#banderaEstado").val("2");
}
// onclick javascript porque no podia saber cual era el id del reembolso, me lo seteaba y estaba mal
function reembolsoRealizado(a) {
    $("#modal_enviar_comentario_soporte").modal("show");
    $("#idReembolso").val(a);
    $("#banderaEstado").val("1");
}
