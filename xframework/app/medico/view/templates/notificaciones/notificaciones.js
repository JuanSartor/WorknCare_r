$(document).ready(function () {
    //cargamos el primer listado 
    x_loadModule('notificaciones', 'notificaciones_no_leidas', 'do_reset=1', 'div_notificaciones_list', BASE_PATH + "medico");


//seleccionar menu - recargar listado
    $('#filters a').click(function () {
        var ourClass = $(this).attr('class');
        var target_listado = $(this).data("target");
        $('#filters li').removeClass('active');
        $(this).parent().addClass('active');
        if (ourClass == 'nt-all') {
            $('#notificaciones-container').children('div.item').fadeIn('slow');
        } else {
            $('#notificaciones-container').children('div:not(.' + ourClass + ')').hide();
            $('#notificaciones-container').children('div.' + ourClass).fadeIn('slow');
        }

        $("#div_notificaciones_list").html("");
        x_loadModule('notificaciones', target_listado, 'do_reset=1', 'div_notificaciones_list', BASE_PATH + "medico");
        return false;
    });

    //delegacion eventos desplegar notificaciones
    $('#div_notificaciones_list').on('click', '.item .item-open', function () {
        var id = $(this).data("idnotificacion");
        /**cerrar**/
        if ($(this).attr('data-click-state') == 1) {
            $(this).attr('data-click-state', 0);
            $(this).children('i').removeClass('fa-minus');
            $(this).children('i').addClass('fa-plus');
            $(this).nextAll().find(".item-contenido").css({height: '55px'});

            if ($("#div_cut_class_" + id).length == 1) {
                $("#div_cut_class_" + id).show();
                $("#div_class_" + id).hide();
            }
            //mostramos boton responder
            $(this).parent().find(".btn-responder-mensaje").show();
        } else {
            /**desplegar**/

            //cerramos las otras notificaciones
            $(".item .item-open").attr('data-click-state', 0);
            $(".item .item-open").children('i').removeClass('fa-minus');
            $(this).attr('data-click-state', 1);
            $(this).children('i').addClass('fa-minus');
            $(this).children('i').removeClass('fa-plus');
            $(".item-contenido").css({height: '55px'});
            $(this).nextAll('.col-md-8').find(".item-contenido").height('auto');


            $(this).attr('data-click-state', 1);
            $(this).next().find(".item-contenido").height('auto');
            $(this).find("i").addClass("fa-minus");

            $(this).find("i").addClass("fa-minus");
            if ($("#div_cut_class_" + id).length == 1) {
                $("#div_cut_class_" + id).hide();
                $("#div_class_" + id).show();
            }
            //mostramos en las otras notificaciones el boton responder
            $(".btn-responder-mensaje").show();
            //ocultamos boton responder de esta notificaciones
            $(this).parent().find(".btn-responder-mensaje").hide();
        }

        //marcar notificacion como leida
        if ($("#item-" + id + " .no-leido").length > 0) {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'marcar_leido.do',
                    "ids=" + $(this).data("idnotificacion") + "&leido=1",
                    function (data) {
                        actualizar_notificaciones();
                        if (data.result) {
                            $("#item-" + id + " .no-leido").remove();
                        }
                    }
            );
        }

    });
    /**
     * TURNOS
     * 
     */
    //Cambiar estado turno
    $('#div_notificaciones_list').on('click', '.btnCambiarEstadoTurno', function () {
        var idturno = $(this).data("idturno");
        var idnotificacion = $(this).data("idnotificacion");
        var redirect_url = $(this).data("redirect");
        jConfirm({
            title: x_translate("Cambiar estado"),
            text: x_translate("Está seguro de que desea confirmar el turno?"),
            confirm: function () {
                $("body").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "cambiar_turno.do",
                        "idturno=" + idturno + "&estado=" + 1 + "&idnotificacion=" + idnotificacion,
                        function (data) {
                            if (data.result) {

                                $("body").spin(false);
                                x_alert(data.msg, function () {
                                    $("body").spin("large");
                                    recargar(redirect_url);
                                });

                            } else {
                                $("body").spin(false);
                                x_alert(data.msg);

                            }
                        }
                );
            },
            cancel: function () {

            },
            confirmButton: x_translate("Si"),
            cancelButton: x_translate("No")
        });
    });
    /**
     * MENSAJES
     * 
     */
    //enviar respuesta a mensaje
    $('#div_notificaciones_list').on('click', '.btnEnviarRespuesta', function () {
        var id = $(this).data("id");
        if (parseInt(id) > 0) {

            if ($("#texto_responder_mensaje_" + id).val() == "") {
                x_alert(x_translate("Ingrese el texto del mensaje"));
            } else {
                $("body").spin("large");
                x_sendForm($('#responder_mensaje_' + id), true, function (data) {
                    $("body").spin(false);
                    x_alert(data.msg);
                    if (data.result) {
                        $("#texto_responder_mensaje_" + id).val("");
                        $("a.icon-toggle.item-open[data-idnotificacion=" + id + "]").click();
                    }
                });
            }
        }
    });
    //listener boton responder mensaje
    $('#div_notificaciones_list').on('click', '.btn-responder-mensaje', function () {
        var id = $(this).data("id");
        $("#btn_plus_" + id).trigger("click");
    });
    /**
     * RENOVACION  RECETAS
     * 
     */
    // renovar receta
    $('#div_notificaciones_list').on('click', '.btn_renovar_receta', function () {
        var target_listado = $('#filters li.active a').data("target");
        var id = $(this).data("id");
        if (parseInt(id) > 0) {
            x_sendForm($('#renovar_receta_' + id), true, function (data) {
                x_alert(data.msg);
                if (data.result) {
                    x_loadModule('notificaciones', target_listado, 'do_reset=1', 'div_notificaciones_list', BASE_PATH + "medico", "", actualizar_notificaciones);

                }
            });
        }
    });
    //enviar motivo rechazo renovacion receta
    $('#div_notificaciones_list').on('click', '.enviar_motivo', function () {
        var target_listado = $('#filters li.active a').data("target");
        var id = $(this).data("id");
        if (parseInt(id) > 0) {
            x_sendForm($('#send_motivo_' + id), true, function (data) {
                x_alert(data.msg);
                if (data.result) {
                    x_loadModule('notificaciones', target_listado, 'do_reset=1', 'div_notificaciones_list', BASE_PATH + "medico", "", actualizar_notificaciones);
                }
            });
        }
    });

    $('#div_notificaciones_list').on('click', '.rechazar_solicitud', function () {
        var id = $(this).data("id");
        if (parseInt(id) > 0) {
            $("#div_renovar_" + id).hide();
            $("#div_cancelar_" + id).show();
        }
    });

    $('#div_notificaciones_list').on('click', '.renovar_receta', function () {
        var id = $(this).data("id");
        if (parseInt(id) > 0) {
            $("#div_renovar_" + id).show();
            $("#div_cancelar_" + id).hide();
        }
    });

    $('#div_notificaciones_list').on('click', '.cancelar_accion', function () {
        var id = $(this).data("id");
        if (parseInt(id) > 0) {
            $("#div_renovar_" + id).hide();
            $("#div_cancelar_" + id).hide();
        }
    });


    $('#div_notificaciones_list').on('click', '.btn-slider', function () {
        var targetId = '#' + $(this).data('target');
        var targetClass = '.' + $(this).data('target');

        // $(targetClass).slideToggle();
        $(this).parents('.item-contenido').children(targetClass).slideToggle();
        if (targetClass != ".opcion-renovacion") {
            $(this).parents('.item-contenido').children(".opcion-renovacion").slideUp();
        } else {
            $(this).parents('.item-contenido').children(".opcion-receta").slideUp();
        }

    });


    /**
     * NOTIFICACIONES SISTEMA
     * 
     */

    //enviar respuesta invitacion prestador
    $('#div_notificaciones_list').on('click', '.respuesta_invitacion_prestador', function () {
        var target_listado = $('#filters li.active a').data("target");
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'respuesta_invitacion_prestador.do',
                "idprestador=" + $(this).data("idprestador") + "&estado=" + $(this).data("estado"),
                function (data) {
                    x_alert(data.msg);
                    actualizar_notificaciones();
                    if (data.result) {
                        x_loadModule('notificaciones', target_listado, 'do_reset=1', 'div_notificaciones_list', BASE_PATH + "medico", "", actualizar_notificaciones);
                    }
                }
        );
    });
});