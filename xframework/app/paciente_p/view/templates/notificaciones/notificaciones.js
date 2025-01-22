
$(document).ready(function () {

    x_loadModule('notificaciones', 'notificaciones_no_leidas', 'do_reset=1', 'div_notificaciones_list', BASE_PATH + "paciente_p");

//seleccionar menu - recargar listado
    $('#filters a').click(function () {

        var ourClass = $(this).attr('class');
        var target_listado = $(this).data("target");
        console.log("click" + ourClass + target_listado);
        $('#filters li').removeClass('active');
        $(this).parent().addClass('active');
        if (ourClass == 'nt-all') {
            $('#notificaciones-container').children('div.item').fadeIn('slow');
        } else {
            $('#notificaciones-container').children('div:not(.' + ourClass + ')').hide();
            $('#notificaciones-container').children('div.' + ourClass).fadeIn('slow');
        }

        $("#div_notificaciones_list").html("");
        x_loadModule('notificaciones', target_listado, 'do_reset=1', 'div_notificaciones_list', BASE_PATH + "paciente_p");
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

            //marcar notificacion como leida
            if ($("#item-" + id + " .no-leido").length > 0) {
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'marcar_leido_p.do',
                        "ids=" + $(this).data("idnotificacion") + "&leido=1",
                        function (data) {
                            actualizar_notificaciones($("#paciente_seleccionado").val());
                            if (data.result) {
                                $("#item-" + id + " .no-leido").remove();
                            }
                        }
                );
            }
        }
    });
    $('#div_notificaciones_list').on('click', '.item', function () {
        var id = $(this).data("idnotificacion");
//marcar notificacion como leida
        if ($("#item-" + id + " .no-leido").length > 0) {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'marcar_leido_p.do',
                    "ids=" + $(this).data("idnotificacion") + "&leido=1",
                    function (data) {
                        actualizar_notificaciones($("#paciente_seleccionado").val());
                        if (data.result) {
                            $("#item-" + id + " .no-leido").remove();
                        }
                    }
            );
        }
    });
    //listener boton responder mensaje
    $('#div_notificaciones_list').on('click', '.btn-responder-mensaje', function () {
        var id = $(this).data("id");
        $("#btn_plus_" + id).trigger("click");
    });


    /**
     * Info sistema
     * */
//respuesta invitacion medico
    $('#div_notificaciones_list').on('click', '.respuesta_invitacion_medico', function () {
        var target_listado = $('#filters li.active a').data("target");
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'respuesta_invitacion_medico.do',
                "idnotificacion=" + $(this).data("idnotificacion") + "&estado=" + $(this).data("estado"),
                function (data) {
                    x_alert(data.msg);
                    actualizar_notificaciones($("#paciente_seleccionado").val());
                    if (data.result) {
                        x_loadModule('notificaciones', target_listado, 'do_reset=1', 'div_notificaciones_list', BASE_PATH + "paciente_p", "", actualizar_notificaciones);
                    }
                }
        );
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
}
);