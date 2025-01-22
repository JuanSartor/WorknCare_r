x_runJS();
$("#modulo").val("pacientes");
$("#submodulo").val("pacientes_generica_form");

$("#btnGuardar").click(function () {



    x_sendForm($('#f_record'), true, function (data) {
        x_alert(data.msg);
        if (data.result) {
            x_loadModule('pacientes', 'pacientes_generica_list', '', 'Main');
        }


    });

});
$("#cargar_credito").click(function () {

    x_loadWindow(this, 'pacientes', 'cargar_credito_form_win', 'id=' + $("#idpaciente").val(), 800, 250);

});
;
$("#back").click(function () {
    x_goTo('pacientes', 'pacientes_generica_list', '', 'Main', this);
});

//habilitamos el plan de la obra social cuando se selecciono una obra social
$("#idobraSocial").change(function () {
    updateComboBox(this, 'idplanObraSocial', 'ManagerPlanesObrasSociales', 'getCombo', 2, "Seleccione...", doUpdateComboBox);
    $("#idplanObraSocial").prop("selectedIndex", 0).change();
});
$('#as_obra_social').autocomplete({
    zIndex: 10000,
    serviceUrl: BASE_PATH + 'obrasocial_autosuggest_x.do',
    onSelect: function (data) {
        $("#idobraSocial").val(data.data).change();
    }
});


$("#btnIntentosFallidos").click(function () {
    var url = "xadmin.php?";
    var queryStr = "action=1&modulo=usuarios&submodulo=reset_intentos_fallidos&idusuarioweb=" + $("#idusuarioweb").val();

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                if (data.result) {
                    $("#btnIntentosFallidos").hide();
                }
                x_alert(data.msg);
            },
            "",
            "",
            true,
            true);
});

//cambiar contraseña, generar y enviar por mail
$("#change_password").click(function () {
    jConfirm(
            "Desea gener una nueva contraseña y enviarla al paciente?",
            "Cambiar contraseña",
            function (r) {
                if (r) {
                    var url = "xadmin.php?";
                    var queryStr = "action=1&modulo=pacientes&submodulo=edit_password_paciente&idpaciente=" + $("#idpaciente").val();
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

/**
 * Recibe el cambio del radio button, preguntando si el tipo es obra social o prepaga
 */
$("#tipo_cobertura_yes, #tipo_cobertura_no").on("change", function () {

    // Si es Obra social 
    if ($("#tipo_cobertura_yes").is(":checked")) {
        $("#combo_prep").css('display', 'block');
        $("#combo_os").css('display', 'block');
        $("#nro_afiliado").css('display', 'block');
    } else {
        $("#combo_prep").css('display', 'none');
        $("#combo_os").css('display', 'none');
        $("#nro_afiliado").css('display', 'none');
    }
});
$("#btnHabilitarDeshabilitarPaciente").click(function () {
    x_doAjaxCall(
            'POST',
            'xadmin.php?action=1&modulo=pacientes&submodulo=habilitar_deshabilitar_paciente',
            "idpaciente=" + $("#idpaciente").val(),
            function (data) {
                x_alert(data.msg);
                if (data.result) {
                    if ($("#btnHabilitarDeshabilitarPaciente").html() == "Deshabilitar Paciente") {

                        $("#btnHabilitarDeshabilitarPaciente").html("Habilitar Paciente");
                        $("#estado_paciente").html("- Deshabilitado");
                    } else {

                        $("#btnHabilitarDeshabilitarPaciente").html("Deshabilitar Paciente");
                        $("#estado_paciente").html("");
                    }
                }

            }
    );
});