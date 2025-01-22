x_runJS();

$(document).ready(function () {
    $("ul.slider-menu li a").removeClass("active");
    $("ul.slider-menu li i.dpp-patologia").parent().addClass("active");

    //ninguna patologia seleccionada
    $("#ninguna_patologia").change(function () {
        if ($("#ninguna_patologia").is(":checked")) {
            if ($(".bootstrap-tagsinput .tag").length > 0) {
                jConfirm({
                    title: "",
                    text: x_translate("Al guardar los datos se eliminarán todas las patologias cargadas. ¿Desea continuar?"),
                    confirm: function () {
                        $(".tagsinput-primary").hide();

                    },
                    cancel: function () {
                        $('#ninguna_patologia').radiocheck('uncheck');
                    },
                    confirmButton: x_translate("Aceptar"),
                    cancelButton: x_translate("Cancelar")
                });
            }
        } else {
            $(".tagsinput-primary").show();
        }
    });



    $("#idenfermedad").change(function () {
        updateComboBoxSelect2("#idenfermedad", 'idtipoEnfermedad', 'ManagerTipoEnfermedad', 'getCombo', 0, x_translate('Patología'), doUpdateComboBoxSelect2);
    });

    $("#otro_tipo_enfermedad").keypress(function () {
        if ($("#otro_tipo_enfermedad").val() != "") {
            $("#idenfermedad").val(14);
            $("#idtipoEnfermedad").val("");
            renderUI2("div_enfermedades_patologias");
        }
    });
    $("#btnAgregarPatologia").click(function () {

//otro tipo de enfermedades
        if ($("#otro_tipo_enfermedad").val() != "") {
            $("#antecedentes_form_2").spin("large");


            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'add_enfermedades_actuales.do',
                    'otro_tipo_enfermedad=' + $("#otro_tipo_enfermedad").val() + '&idenfermedad=' + $("#idenfermedad").val() + "&enfermedad=1",
                    function (data) {
                        $("#antecedentes_form_2").spin(false);

                        if (data.result) {

                            $('#patologias_tag_input').tagsinput('add', {"value": data.id, "text": $("#otro_tipo_enfermedad").val()});
                            $("#ninguna_patologia").prop('checked', false);
                            $("#idenfermedad").val("");
                            $("#otro_tipo_enfermedad").val("");
                            renderUI2("div_enfermedades_patologias");
                        } else {
                            x_alert(data.msg);
                        }
                    }
            );
        } else {
            //enfermedades seleccionadas combo
            if ($("#idenfermedad").val() != "" && $("#idenfermedad").val() != 14 && $("#idtipoEnfermedad").val() != "") {
                $("#antecedentes_form_2").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'add_enfermedades_actuales.do',
                        'idtipoEnfermedad=' + $("#idtipoEnfermedad").val(),
                        function (data) {
                            $("#antecedentes_form_2").spin(false);

                            if (data.result) {

                                $('#patologias_tag_input').tagsinput('add', {"value": data.id, "text": data.tipoEnfermedad});
                                $("#ninguna_patologia").prop('checked', false);
                                $("#idtipoEnfermedad").val("");
                                $("#idenfermedad").val("");
                                $("#otro_tipo_enfermedad").val("");
                                renderUI2("div_enfermedades_patologias");
                            } else {
                                x_alert(data.msg);
                            }
                        }
                );
            }
        }
    });

    var unchecked = function (sel1, sel2, sel3) {
        $(sel1).change(function (e) {
            $(sel2).prop('checked', false);
            $(sel3).prop('checked', false);
        });

        $(sel2).change(function (e) {
            $(sel1).prop('checked', false);
            $(sel3).prop('checked', false);
        });

        $(sel3).change(function (e) {
            $(sel2).prop('checked', false);
            $(sel1).prop('checked', false);
        });

    };
    /*
     if ($("#ninguna_patologia").is(":checked")) {
     
     }
     $("#ninguna_patologia").change(function () {
     if ($("#ninguna_patologia").is(":checked")) {
     $("#div_enfermedades_patologias").hide();
     } else {
     $("#div_enfermedades_patologias").show();
     }
     });
     */
    unchecked("#varicela-si", "#varicela-no", "#varicela-nose");
    unchecked("#rubiola-si", "#rubiola-no", "#rubiola-nose");
    unchecked("#sarampion-si", "#sarampion-no", "#sarampion-nose");
    unchecked("#escarlatina-si", "#escarlatina-no", "#escarlatina-nose");
    unchecked("#eritema-si", "#eritema-no", "#eritema-nose");
    unchecked("#exatema-si", "#exatema-no", "#exatema-nose");
    unchecked("#papera-si", "#papera-no", "#papera-nose");


    unchecked("#hepatitisA-si", "#hepatitisA-no", "#hepatitisA-nose");
    unchecked("#hepatitisB-si", "#hepatitisB-no", "#hepatitisB-nose");
    unchecked("#hepatitisC-si", "#hepatitisC-no", "#hepatitisC-nose");
    unchecked("#VPH-si", "#VPH-no", "#VPH-nose");
    unchecked("#HIV-si", "#HIV-no", "#HIV-nose");


    unchecked("#otitis-oder", "#otitis-oizq", "#otitis-ambos");


    $("#btn_save_antecedentes").click(function () {

        if ($("#antecedentes_form_1 input:checkbox:checked").length == 0) {
            x_alert(x_translate("Debe completar la información para guardar"));
            return false;
        }

        var actualice = true;
        if ($("#idantecedentesPersonales").val() != "") {
            actualice = false;
        }


        $("#antecedentes_form_1").spin("large");
        x_sendForm($('#antecedentes_form_1'),
                true,
                function (data) {
                    $("#antecedentes_form_1").spin(false);

                    actualizar_menu_status_perfilsalud();
                    if (data.result) {
                        x_alert(data.msg, recargar);
                    } else {
                        x_alert(data.msg);
                    }
                }
        );
    });

    $("#btn_save_antecedentes2").click(function () {
        var actualice = true;
        if ($("#idenfermedadesActuales").val() != "") {
            actualice = false;
        }


        $("#antecedentes_form_2").spin("large");
        x_sendForm($('#antecedentes_form_2'),
                true,
                function (data) {
                    $("#antecedentes_form_2").spin(false);
                    $("#idenfermedadesActuales").val(data.id);

                    actualizar_menu_status_perfilsalud();
                    if (data.result) {
                        x_alert(data.msg, recargar);
                    } else {
                        x_alert(data.msg);
                    }
                }
        );
    });

    $("#btn_save_antecedentes3").click(function () {

        if ($("#antecedentes_form_3 input:checkbox:checked").length == 0) {
            x_alert(x_translate("Debe completar la información para guardar"));
            return false;
        }

        var actualice = true;
        if ($("#idpatologiasActuales").val() != "") {
            actualice = false;
        }


        $("#antecedentes_form_3").spin("large");
        x_sendForm($('#antecedentes_form_3'),
                true,
                function (data) {
                    $("#antecedentes_form_3").spin(false);

                    actualizar_menu_status_perfilsalud();
                    if (data.result) {
                        x_alert(data.msg, recargar);
                    } else {
                        x_alert(data.msg);
                    }
                }
        );
    });




    //cuando se checkea la opcion NO o NOSE de antecedenes personales, se limpia el campo de edad de la enfermedad
    $("#antecedentes_form_1 :checkbox").each(function () {
        if ($(this).val() == 0 || $(this).val() == 2) {
            $(this).click(function () {
                var name = $(this).attr("name");
                $("#" + name + "-edad").val("");
            });

        }
    });

    $("#VPH-no, #VPH-nose").click(function () {
        $("#edad_vacuna_vph").val("");
    });










});

