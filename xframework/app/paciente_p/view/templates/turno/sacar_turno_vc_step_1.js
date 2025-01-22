$(document).ready(function () {
    $(".ce-nc-steps li.ce-nc-step").removeClass("actual");
    $(".ce-nc-steps li.ce-nc-step").eq(0).addClass("actual");
    $("#Main").spin(false);
    renderUI2();
    // Inicialización de los checks
    $(':checkbox').radiocheck();

    $('#particular').on('change.radiocheck', function (e) {
        $("#particular").prop('checked', true);
    });

    $('.bst-cambiar-pacientes-trigger').on('click', function (e) {
        e.preventDefault();
        $(this).next('.bst-cambiar-pacientes-slide').slideToggle();
        $(this).children('.icon-doctorplus-arrow-down').toggleClass('btn-up-arrow');
    });


    $("#motivoVideoConsulta_idmotivoVideoConsulta").change(function () {
        $("#motivoVideoConsulta_idmotivoVideoConsulta_reservar").val($("#motivoVideoConsulta_idmotivoVideoConsulta").val());
    });

    //desmarcamos los programas que no son ofrecidos por la empresa
    if (ids_excepciones_programa !== "") {
        if (ids_excepciones_programa !== "ALL") {
            ids_excepciones_programa.split(',').forEach(function (id) {
                $(".programa-destacado-tag[data-id=" + id + "]").addClass("hide");
            });
            $(".programa-destacado-tag:not(.hide)").show();
        } else {
            $(".programa-destacado-tag").show();
        }
    }
    //marcamos el programa o categoria seleccionado
    $(".select-programa").click(function (e) {
        e.preventDefault();
        e.stopPropagation();
        let idprograma = $(this).data("idprograma");
        $(".select-programa").not("[data-idprograma=" + idprograma + "]").removeClass("open");
        $(this).toggleClass("open");
    });
    //marcamos el programa o categoria seleccionado
    $(".select-categoria").click(function (e) {
        e.preventDefault();
        $(".item-seleccionado").html("");
        $("#idprograma_categoria").val("");
        $("#idprograma_salud").val("");
        if ($(this).data("idprograma") != "") {
            let idprograma = $(this).data("idprograma");
            $(".item-seleccionado").append($(".nombre-programa[data-idprograma=" + idprograma + "]").clone());
            $("#idprograma_salud").val(idprograma);
        }
        if ($(this).data("idcategoria") != "") {
            let idcategoria = $(this).data("idcategoria");
            $(".item-seleccionado").append($(".nombre-categoria[data-idcategoria=" + idcategoria + "]").clone());
            $("#idprograma_categoria").val(idcategoria);
        }

        $(".label-default").hide();
        $(".item-seleccionado").show();
        updateComboBoxSelect2("#idprograma_categoria", 'motivoVideoConsulta_idmotivoVideoConsulta', 'ManagerMotivoVideoConsulta', 'getComboByProgramaCategoria', 0, x_translate('Seleccione una opción'), doUpdateComboBoxSelect2);


    });


    $("#paciente-existente").click(function () {
        if ($(this).is(':checked')) {
            $("#visitaPrevia_reservar").val(1);
        }
    });


    $("#btn_reservar").click(function () {

        if ($("#motivoVideoConsulta_idmotivoVideoConsulta_reservar").val() == "") {
            x_alert(x_translate("Seleccione motivo de videoconsulta"));
            return false;
        }

        if ($("#text-msg").val().length === 0) {
            x_alert(x_translate("Ingresa el texto de la consulta con el mayor detalle posible para una respuesta más rápida y precisa."));
            $("#text-msg").addClass("select-required");
            return false;
        }

        //carga de imagenes en proceso
        if ($("#dropzone .dz-complete").length !== $("#dropzone .dz-preview").length) {
            x_alert(x_translate("Aguarde mientras se cargan los archivos adjuntos"));
            return false;

        }

        //Mostramos el modal de privacidad del perfil de salud
        if ($("#mostrar_cambio_privacidad").val() === "1") {
            $("#modal-cambio-privacidad-perfil-salud").modal('show');
            return false;
        }
        if ($("#beneficia_reintegro").is(":checked")) {
            $("#beneficia_reintegro_reservar").val(1);
            $("#particular_reservar").val(0);
        } else {
            $("#beneficia_reintegro_reservar").val(0);
            $("#particular_reservar").val(1);
        }



        $("#Main").spin("large");
        x_sendForm($('#reservar_turno'),
                true,
                function (data) {
                    $("#Main").spin(false);
                    if (data.result) {
                        //verificamos el dispositivo - Test RTC
                        var hide_checkrtc_modal_paciente = localStorage.getItem('hide_checkrtc_modal_paciente');
                        if (hide_checkrtc_modal_paciente != 1) {
                            $("#checkRTC_container").empty();
                            $("#checkRTC_container").spin("large");
                            $("#run-checkrtc").modal("show");

                            x_loadModule('check_rtc', 'checkRTC', '', 'checkRTC_container').then(function () {
                                $("#checkRTC_container").spin(false);
                            });
                        } else {
                            $("#Main").spin("large");
                            x_loadModule('turno', 'sacar_turno_vc_step_3', 'turno=' + $("#idturno_reservar").val(), 'reservar_turno_container', BASE_PATH + "paciente_p").then(function () {
                                $("#Main").spin(false);
                            });
                        }

                    } else {
                        x_alert(data.msg);
                    }
                });
    });
    //recargar el test rtc
    if (localStorage.getItem('reload_checkrtc_paciente') == 1) {
        localStorage.removeItem('reload_checkrtc_paciente');
        console.log("reload test rtc");
        $("#btn_reservar").trigger("click");
    }

    $("#btnCancelar").click(function () {
        $("#Main").spin("large");
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'cancelar_from_creacion.do',
                'id=' + $("#idturno_reservar").val(),
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

    //seteamos la variable de cambio de privacidad
    $("#btnCambiarPrivacidad").click(function () {
        $("body").spin("large");
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'save_privacidad.do',
                'idpaciente=' + $("#paciente_idpaciente_reservar").val() + '&perfil-privado=1',
                function (data) {
                    $("body").spin(false);
                    if (data.result) {
                        $("#mostrar_cambio_privacidad").val(0);
                        $("#modal-cambio-privacidad-perfil-salud").modal('hide');
                        $("#btn_reservar").trigger('click');
                    } else {
                        x_alert(data.msg);
                    }
                });

    });

});