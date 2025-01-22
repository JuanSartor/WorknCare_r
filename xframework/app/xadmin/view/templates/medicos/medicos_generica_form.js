x_runJS();
$("#modulo").val("medicos");
$("#submodulo").val("medicos_generica_form");

$("#btnGuardar").click(function () {


    //expresion regular para mail
    if (!validarEmail($("#email_input").val())) {
        x_alert("Ingrese un email válido");

        return false;
    }


    x_sendForm(
            $('#f_record'),
            true,
            callback_update
            );

});

var callback_update = function (data) {
    x_alert(data.msg);
    if (data.result) {
        x_loadModule('medicos', 'medicos_generica_list', '', 'Main');
    }
};

$("#back").click(function () {
    x_goTo('medicos', 'medicos_generica_list', '', 'Main', this);
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
            "Desea gener una nueva contraseña y enviarla al médico?",
            "Cambiar contraseña",
            function (r) {
                if (r) {
                    var url = "xadmin.php?";
                    var queryStr = "action=1&modulo=medicos&submodulo=edit_password_medico&idmedico=" + $("#idmedico").val();
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




//crear suscripcion profersional por un periodo 
$("#btnPlanProfesional").click(function () {
    var planProfesional = $("#planProfesional").val();
    if ($("#cantidad_meses").val() == 13 && planProfesional == 0) {
        var value = 1;

        var txt = "Desea marcar este médico como fundador ?";
        var txt_button_callback = "Desactivar Cuenta Profesional";
    } else {


        if (planProfesional == 0) {
            var value = 1;
            var meses = $("#cantidad_meses option:selected").text();
            var txt = "Desea generar una nueva cuenta profesional por " + meses + " para este médico?";
            var txt_button_callback = "Desactivar Cuenta Profesional";


        } else {
            var value = 0;
            var txt = "Desea eliminar la cuenta profesional de este médico?";
            var txt_button_callback = "Activar Cuenta Profesional";

        }
    }
    jConfirm(
            txt,
            "Cuenta Profesional",
            function (r) {
                if (r) {
                    $("#activar_cuenta_profesional").val(value);

                    x_sendForm(
                            $('#f_cuenta_profesional'),
                            true,
                            function (data) {

                                x_alert(data.msg);
                                if (data.result) {

                                    x_goTo('medicos', 'medicos_generica_form', 'id=' + $("#idmedico").val(), 'Main', this);
                                    $("#planProfesional").val(value);

                                    $("#btnPlanProfesional").html(txt_button_callback);

                                    if (planProfesional == 0) {
                                        $("#btnPlanProfesional").removeClass("approve");
                                        $("#btnPlanProfesional").addClass("remove");
                                    } else {
                                        $("#btnPlanProfesional").removeClass("remove");
                                        $("#btnPlanProfesional").addClass("approve");
                                    }
                                }
                            }
                    );



                }
            }
    );
});




//aprobar validacion de datos del medico
$("#btnAprobarMedico").click(function () {
    var url = "xadmin.php?";
    var queryStr = "action=1&modulo=medicos&submodulo=validar_medico&idmedico=" + $("#idmedico").val();

    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                if (data.result) {
                    if (parseInt($("#validado").val()) == 0) {
                        $("#validado").val(1);
                        $("#btnAprobarMedico").html("Suspender Valicación");
                        $("#estado_medico").html("Médico validado");
                        $("#estado_medico").css("color", "green");
                        $("#btnAprobarMedico").addClass("remove");
                        $("#btnAprobarMedico").removeClass("approve");
                    } else {
                        $("#validado").val(0);
                        $("#estado_medico").html("Pendiente de validación por DoctorPlus");
                        $("#estado_medico").css("color", "red");
                        $("#btnAprobarMedico").html("Validar Médico");
                        $("#btnAprobarMedico").addClass("approve");
                        $("#btnAprobarMedico").removeClass("remove");
                    }
                }
                x_alert(data.msg);
            },
            "",
            "",
            true,
            true);
});

//activar/desactivar cuenta
$("#btnActivar").click(function () {
    var url = "xadmin.php?";
    if (parseInt($("#active").val()) == 0) {
        var queryStr = "action=1&modulo=medicos&submodulo=activemultiple_medico&ids=" + $("#idmedico").val();
    } else {
        var queryStr = "action=1&modulo=medicos&submodulo=deletemultiple_medico_gen&ids=" + $("#idmedico").val();
    }


    x_doAjaxCall("POST",
            url,
            queryStr,
            function (data) {
                if (data.result) {
                    if (parseInt($("#active").val()) == 0) {
                        $("#active").val(1);
                        $("#btnActivar").html("Desactivar cuenta");
                    } else {
                        $("#active").val(0);
                        $("#btnActivar").html("Activar cuenta");
                    }
                }
                x_alert(data.msg);
            },
            "",
            "",
            true,
            true);
});


$("#especialidad_medico").change(function () {
    updateComboBox(this, 'subespecialidad_medico', 'ManagerSubEspecialidades', 'getCombo', 2);
});

$("#cuit_input").inputmask("99-99999999-9");

//adjuntar documentacion
$("#btnAdjuntar").click(function () {
    x_loadWindow(this, 'medicos', 'medicos_documentacion_form', 'idmedico=' + $("#idmedico").val(), 800, 400);

});

x_loadModule('medicos', 'medicos_documentacion_list', 'id=' + $("#idmedico").val(), 'div_listado_documentacion');



