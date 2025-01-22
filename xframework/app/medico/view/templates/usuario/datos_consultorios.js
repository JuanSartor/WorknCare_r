
renderUI2("Main");
$(function () {
    $('.switch-checkbox').bootstrapSwitch();
    $(':checkbox').radiocheck();
    $(':radio, :checkbox').radiocheck();
    $('[data-toggle="tooltip"]').tooltip();

    //guardar configuracion- preferencia utilizar agenda consultorios
    $(".btn-siguiente-agenda-consultorio").click(function () {
        if (!$("#agenda_consultorio_si").is(":checked") && !$("#agenda_consultorio_no").is(":checked")) {
            x_alert(x_translate("Seleccione al menos una opción"));
            return false;
        }
        if ($("#agenda_consultorio_si").is(":checked")) {
            var agenda_consultorio = 1;
        } else {
            var agenda_consultorio = 0;
        }
        $("body").spin("large");
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'setear_agenda_consultorio.do',
                "agenda_consultorio=" + agenda_consultorio,
                function (data) {
                    $("body").spin(false);

                    if (data.result) {
                        //quitamos alerts
                        $("#headingTwo .alert-req-field").remove();
                        if ($("#div_datos_consultorios .alert-req-field").length == 0) {
                            $("a[data-src='#consultorios'] p.span_alert").remove();
                        }
                        //recargamos el menu de usuario
                        x_loadModule('usuario', 'menu_usuario', 'sm=datos_consultorios', 'div_menu_usuario', BASE_PATH + "medico");


                        //siguiente paso
                        if (agenda_consultorio === 0) {//ir a tarifas
                            $(".consultorios-trg[data-src='#tarifas']").trigger("click");
                        } else {//ir a la config agenda de consultorio
                            x_loadModule('usuario', 'datos_consultorios_items', '', 'div_items_consultorios');
                            $("#div_consulta_agenda_consultorio").hide();
                            $("#div_items_consultorios").slideDown();

                        }
                    } else {
                        x_alert(data.msg);
                    }

                }
        );
    });



    //CODIGO JS CONSULTORIOS
    $('.consultorios-trg').on('click', function (e) {
        e.preventDefault();

        if (!($(this).hasClass('active'))) {

            $('.consultorios-trg').removeClass('active');
            $(this).addClass('active');

            $('.consultorios-src').slideUp();
            $($(this).data('src')).slideDown();
        }
    });

    $('#dc-del-content-trg').on('click', function (e) {
        e.preventDefault();
        $('#dc-del-content').slideUp();
        $('#dc-del-disclaimer').slideDown();

    });

    $('.dc-modal-del').on('click', function (e) {
        e.preventDefault();
        $('#dc-modal-con-del').modal(['show']);
    });

    $('#dc-modal-notificacion-pacientes-trg').on('click', function (e) {
        e.preventDefault();
        $('#dc-modal-info-pacientes').modal(['show']);
    });



    //CODIGO JS TARIFAS Y SERVICIOS



    var alert_resultado_tarifas = function (data) {
        if (data.result) {

            //verificamos si está todo completo
            let completo = true;
            $("#frm_aranceles input[type='number']").each(function (index, tarifa) {
                if (tarifa.value == "") {
                    completo = false;
                }
            });
            if (completo) {
                $("#headingOne-a2 .alert-req-field").remove();
                $("a[data-src='#tarifas'] p.span_alert").remove();
            }

            //recargamos el menu de usuario
            x_loadModule('usuario', 'menu_usuario', 'sm=datos_consultorios', 'div_menu_usuario', BASE_PATH + "medico");

        }
        if (data.result && data.showModal) {
            x_alert(x_translate("Se han completado sus datos profesionales minimos para poder operar en DoctorPlus"), function () {
                recargar(BASE_PATH + "panel-medico/");
            });
        } else {
            x_alert(data.msg);
        }

    };


    $("#guardarAranceles").click(function () {

        if ($("#valorPinesConsultaExpress").val() === "" || parseFloat($("#valorPinesConsultaExpress").val()) < parseFloat($("#PRECIO_MINIMO_CE").val())) {
            x_alert(x_translate("El valor de Consulta Express no puede ser menor a") + " &euro;" + $("#PRECIO_MINIMO_CE").val());
            return false;
        }
        if ($("#valorPinesConsultaExpress").val() === "" || parseFloat($("#valorPinesConsultaExpress").val()) > parseFloat($("#PRECIO_MAXIMO_CE").val())) {
            x_alert(x_translate("El valor de Consulta Express no puede ser mayor a") + " &euro;" + $("#PRECIO_MAXIMO_CE").val());
            return false;
        }
        if ($("#valorPinesVideoConsultaTurno").val() === "" || parseFloat($("#valorPinesVideoConsultaTurno").val()) < parseFloat($("#PRECIO_MINIMO_VC_TURNO").val())) {
            x_alert(x_translate("El valor de la Video Consulta con turno no puede ser menor a") + " &euro;" + $("#PRECIO_MINIMO_VC_TURNO").val());
            return false;
        }
        if ($("#valorPinesVideoConsultaTurno").val() === "" || parseFloat($("#valorPinesVideoConsultaTurno").val()) > parseFloat($("#PRECIO_MAXIMO_VC_TURNO").val())) {
            x_alert(x_translate("El valor de la Video Consulta con turno no puede ser mayor a") + " &euro;" + $("#PRECIO_MAXIMO_VC_TURNO").val());
            return false;
        }
        if ($("#valorPinesVideoConsulta").length > 0) {
            if ($("#valorPinesVideoConsulta").val() === "" || parseFloat($("#valorPinesVideoConsulta").val()) < parseFloat($("#PRECIO_MINIMO_VC").val())) {
                x_alert(x_translate("El valor de la Video Consulta inmediata no puede ser menor a") + " &euro;" + $("#PRECIO_MINIMO_VC").val());
                return false;
            }
            if ($("#valorPinesVideoConsulta").val() === "" || parseFloat($("#valorPinesVideoConsulta").val()) > parseFloat($("#PRECIO_MAXIMO_VC").val())) {
                x_alert(x_translate("El valor de la Video Consulta inmediata no puede ser mayor a") + " &euro;" + $("#PRECIO_MAXIMO_VC").val());
                return false;
            }
        }

        x_sendForm($('#frm_aranceles'), true, alert_resultado_tarifas);
    });
    //metodos al chequear las opciones de configuracion de servicio de consulta express
    $("#pacientesConsultaExpress :radio").on('change.radiocheck', function () {

        var val = $("#pacientesConsultaExpress :radio:checked").val();
        if (val == "1" || val == "2") {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'registrar_preferencia_servicios.do',
                    'pacientesConsultaExpress=' + val,
                    function (data) {
                        x_alert(data.msg);
                    });
        }
    });
    //metodos al chequear las opciones de configuracion de servicio de video consulta
    $("#pacientesVideoConsulta :radio").on('change.radiocheck', function () {

        var val = $("#pacientesVideoConsulta :radio:checked").val();
        if (val == "1" || val == "2") {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'registrar_preferencia_servicios.do',
                    'pacientesVideoConsulta=' + val,
                    function (data) {

                        x_alert(data.msg);

                    });
        }
    });
    //alerta opcion "Solo mis paciente" para cuentas profesionales
    $(".radio-profesional-alert").click(function () {
        if ($(this).find("input:radio:disabled").length > 0) {
            x_alert(x_translate("Necesita suscribir a un abono profesional para personalizar el uso de su cuenta"));
        }

    });



    //CODIGO JS OBRAS SOCIALES

    //autosuggest obra social
    $('#as_obra_social').autocomplete({
        zIndex: 10000,
        serviceUrl: BASE_PATH + 'obrasocial_autosuggest_m.do',
        onSelect: function (data) {
            $("#idobraSocial").val(data.data).change();
        }
    });
    //agregar la obra social
    $("#btnAddObraSocial").click(function () {

        var idobraSocial = $("#idobraSocial").val();
        if (idobraSocial != "") {
            x_doAjaxCall(
                    'POST',
                    'agregarObraSocial.do',
                    "idobraSocial=" + idobraSocial,
                    function (data) {

                        x_alert(data.msg);
                        if (data.result) {

                            $("#obrasocial_tagsinput").tagsinput('add', {"id": idobraSocial, "text": data.nombre});
                            $("#idobraSocial").val("");
                            $('#as_obra_social').val("");
                        }
                    }
            );
        } else {
            x_alert(x_translate("Seleccione una Medicina Prepaga / Obra Social"));
            return false;
        }
    });

    //accion a remover el tag -> eliminanos la asociacion y quitamos el tag
    $('#obrasocial_tagsinput').on('beforeItemRemove', function (event) {


        var id = event.item.id;

        x_doAjaxCall(
                'POST',
                'eliminarObraSocial.do',
                'idobraSocial=' + id,
                function (data) {

                    if (data.result) {
                        x_alert(data.msg);
                        // Remove class when reached maxTags


                    } else {
                        $("#obrasocial_tagsinput").tagsinput("add", {
                            "id": event.item.id, "text": event.item.text});
                    }
                }
        );
    });

    //accion a remover el tag -> eliminanos la asociacion del medico a isic y quitamos el tag
    $('#prestadores_tagsinput').on('beforeItemRemove', function (event) {

        $("#btnAceptarEliminarPrestador,#btnCancelarEliminarPrestador").data("id", event.item.id);
        $("#btnAceptarEliminarPrestador,#btnCancelarEliminarPrestador").data("text", event.item.text);
        $("#modal-eliminar-prestador").modal("show");

    });
    //eliminar relacion prestador
    $("#btnAceptarEliminarPrestador").click(function () {
        var id = $(this).data("id");
        var text = $(this).data("text");
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'eliminar_asociacion_prestador.do',
                'id=' + id,
                function (data) {
                    x_alert(data.msg);
                    if (data.result) {
                        $("#modal-eliminar-prestador").modal("hide");
                        $("#tos-isic").radiocheck("uncheck");
                        $("#div_agregar_isic").slideDown();
                        // Remove class when reached maxTags
                    } else {
                        $("#prestadores_tagsinput").tagsinput("add", {
                            "id": id, "text": text});
                    }
                }
        );
    });
    //cancelar elimnar prestador - restaruar taginput
    $("#btnCancelarEliminarPrestador").click(function () {
        var id = $(this).data("id");
        var text = $(this).data("text");
        $("#prestadores_tagsinput").tagsinput("add", {
            "id": id, "text": text});
        $("#modal-eliminar-prestador").modal("hide");
    })


});