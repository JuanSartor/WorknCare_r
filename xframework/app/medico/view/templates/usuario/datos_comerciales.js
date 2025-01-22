

x_runJS();

var alert_resultado = function (data) {
    $("#Main").spin(false);

    x_alert(data.msg);
    if (data.result) {
        x_loadModule('usuario', 'menu_usuario', 'sm=datos_comerciales', 'div_menu_usuario');
    }
};
$(document).ready(function () {

    $("#btnGuardarInfoComercial").click(function () {
        //validamos los campos obligatorios
        if ($("#iban").val() == "" || $("#repetir_iban").val() == "" || $("#banco_idbanco").val() == "") {
            x_alert(x_translate("Ingrese un código IBAN válido"));
            return false;
        }
        if ($("#iban").val() != $("#repetir_iban").val()) {
            x_alert(x_translate("Ingrese un código IBAN válido"));
            return false;
        }
        if ($("#nombre_beneficiario").val() == "") {
            x_alert(x_translate("Ingrese el nombre del beneficiario de la cuenta"));
            return false;

        }
        if ($(".condicion_iva:checked").val() === "1" && $("#numero_tva").val() === "") {
            x_alert(x_translate("Ingrese número de identificación TVA"));
            return false;
        }

        $("#Main").spin("large");
        x_sendForm($('#frmCambiarDatos'), true, alert_resultado);
    });
    $("#validar_iban").click(function () {
        if ($("#iban").val() == "" || $("#iban").val().length != 27 || $("#iban").val() != $("#repetir_iban").val()) {

            x_alert(x_translate("Ingrese un código IBAN válido"));
            return false;
        }
        x_doAjaxCall(
                'POST',
                BASE_PATH + "get_banco_x_iban.do",
                'iban=' + $("#iban").val(),
                function (data) {
                    if (data.hasOwnProperty("nombre_banco")) {
                        $("#nombre_banco").text(data.nombre_banco);
                        $("#banco_idbanco").val(data.idbanco);
                        $("#div_datos_cuenta").show();

                    } else {
                        x_alert(x_translate("Ingrese un código IBAN válido"));
                        $("#div_datos_cuenta").hide();
                    }
                }

        )

    })

    //mostrar campo numero TVA
    $(".condicion_iva").on('change.radiocheck', function () {
        if ($(".condicion_iva:checked").val() === "1") {
            $("#numero_tva_container").show();
        } else {
            $("#numero_tva_container").hide();
        }
    });


});