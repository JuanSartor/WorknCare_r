$(function () {
    $("#Main").spin(false);
    //flecha ir arriba
    $('#scrollUp').on('click', function (e) {
        e.preventDefault();
        scrollToEl($('.agenda-header'));
    });

    //seleccionar consultorio y cargar agenda de ese consultorio
    $("a.select-consultorio").on("click", (function () {

        var fecha = $("#dia_agenda").val();

        $("#agenda_diaria_medico").spin("large");
        x_loadModule('agenda', 'agenda_diaria', 'fecha=' + fecha + '&idconsultorio=' + $(this).data("id"), 'agenda_diaria_medico');
    }));

//tooltip en modal de turnos
    $('.td-tooltip-btn').tooltipster({
        theme: 'tooltipster-light'
    });

    //ia a la semana previa
    $("#a_get_dia_previous_day").click(function () {
        $("#Main").spin("large");
        var fecha = $("#dia_agenda").val();

        x_loadModule('agenda', 'agenda_diaria', 'previous=1&fecha=' + fecha + '&idconsultorio=' + $("#idconsultorio").val(), 'agenda_diaria_medico');
    });
//ir a la proxima semana
    $("#a_get_dia_next_day").click(function () {
        $("#Main").spin("large");
        var fecha = $("#dia_agenda").val();

        x_loadModule('agenda', 'agenda_diaria', 'next=1&fecha=' + fecha + '&idconsultorio=' + $("#idconsultorio").val(), 'agenda_diaria_medico');
    });

    //desplegar modal de turnos
    $(' a.display-modal').on('click', function (e) {


        if ($(this).data('modal')) {

            var modalData = $(this).data('modal');
            //limpiamos el contenido previo
            $('#' + modalData).find('.btnDetalleTurno').show();
            $('#' + modalData).find('.mensaje-turno-container').hide();
            $('#' + modalData).find('.mensaje-turno-container textarea').val("");
            //mostramos el modal
            $('#' + modalData).modal('show');

        }


    });

    //boton que lleva al detalle turno
    $(".btnDetalleTurno").click(function () {
        var idturno = $(this).data("idturno");
        if (parseInt(idturno) > 0) {
            $element = $(this);
            $modal = $element.parentsUntil(".modal-turnos").last().parent();
            $modal.spin("large");
            window.location.href = BASE_PATH + "panel-medico/agenda/detalle-turno-" + idturno + ".html";
        }
    });
    //declinar turno - desplegar texto mensaje
    $(".declinar-turno").click(function () {
        var id = $(this).data("idturno");
        $(".btnDetalleTurno[data-idturno=" + id + "]").hide();
        //mostramos el boton correspondiente
        $(".mensaje-turno-container[data-idturno=" + id + "] .btnCambiarEstadoTurno").hide();
        $(".mensaje-turno-container[data-idturno=" + id + "] .btnCambiarEstadoTurno[data-action='declinar']").show();
        $(".mensaje-turno-container[data-idturno=" + id + "]").slideDown();
    });
    //cancelar turno - desplegar texto mensaje
    $(".cancelar-turno").click(function () {
        var id = $(this).data("idturno");
        $(".btnDetalleTurno[data-idturno=" + id + "]").hide();
        //mostramos el boton correspondiente
        $(".mensaje-turno-container[data-idturno=" + id + "] .btnCambiarEstadoTurno").hide();
        $(".mensaje-turno-container[data-idturno=" + id + "] .btnCambiarEstadoTurno[data-action='cancelar']").show();
        $(".mensaje-turno-container[data-idturno=" + id + "]").slideDown();
    });
    //cambiar estado del turno
    $(".btnCambiarEstadoTurno").click(function () {
        $element = $(this);
        $modal = $element.parentsUntil(".modal-turnos").last().parent();

        //verificamos el estado correcto y seteamos el mensaje de confirmacion
        var estado = $(this).data("estado");
        var idturno = $(this).data("idturno");
        var mensaje = "";
        if (estado == 1) {
            var txt = x_translate("Está seguro de que desea confirmar el turno?");
            var title = x_translate("Confirmar turno");
            //limpiamos el contenido previo
            $($modal).find('.btnDetalleTurno').show();
            $($modal).find('.mensaje-turno-container').hide();
        } else if (estado == 2) {
            var txt = x_translate("Está seguro de que desea cancelar el turno?");
            var title = x_translate("Cancelar turno");
            mensaje = $(".text-mensaje[data-idturno=" + idturno + "]").val();
        } else if (estado == 3) {
            var txt = x_translate("Está seguro de que desea declinar el turno?");
            var title = x_translate("Declinar turno");
            mensaje = $(".text-mensaje[data-idturno=" + idturno + "]").val();
        } else if (estado == 5) {
            var txt = x_translate("Está seguro de que desea marcar al paciente como Ausente?");
            var title = x_translate("Paciente ausente");
            //limpiamos el contenido previo
            $($modal).find('.btnDetalleTurno').show();
            $($modal).find('.mensaje-turno-container').hide();
        } else {
            return false;
        }

        if (parseInt(idturno) > 0) {
            //confirmar la accion
            jConfirm({
                title: title,
                text: txt,
                confirm: function () {

                    $modal.spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "cambiar_turno.do",
                            "idturno=" + idturno + "&estado=" + estado + "&mensaje=" + mensaje,
                            function (data) {
                                $modal.spin(false);
                                x_alert(data.msg);
                                if (data.result) {
                                    //recargamos el modulo de la agenda semanal con  el turno actualizado
                                    var fecha = $("#dia_agenda").val();
                                    $modal.modal("hide");
                                    $(".modal-backdrop.fade.in").remove();
                                    $('#Main').spin("large");
                                    x_loadModule('agenda', 'agenda_diaria', 'fecha=' + fecha + '&idconsultorio=' + $("#idconsultorio").val(), 'agenda_diaria_medico').then(function () {
                                        $('#Main').spin(false);
                                    });

                                }
                            }
                    );
                },
                cancel: function () {

                },
                confirmButton: x_translate("Si"),
                cancelButton: x_translate("No")
            });
        }
    });


    //boton escribir conclusiones en PerfilSaludConsulta
    $(".btnEscribirConclusiones").click(function () {
        var idturno = $(this).data("idturno");

        $element = $(this);
        $modal = $element.parentsUntil(".modal-turnos").last().parent();
        $modal.spin("large");
        var idpaciente = parseInt($(this).data("idpaciente"));

        if (parseInt(idturno) > 0 && idpaciente > 0) {

            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'panel-medico/change_member.do',
                    "id=" + idpaciente,
                    function (data) {
                        $modal.spin(false);
                        if (data.result) {
                            window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + data.idpaciente + "-" + data.nombre + "-" + data.apellido + "/consultanueva.html?idturno=" + idturno;
                        } else {
                            x_alert(data.msg);
                        }
                    }
            );




        }

    });
    //ir al detalle de consulta medica para los turnos pasados con conclusiones
    $(".btnVerConsultaMedica").click(function () {

        var idpaciente = parseInt($(this).data("idpaciente"));
        var idperfilSaludConsulta = parseInt($(this).data("idperfilsaludconsulta"));

        if (parseInt(idperfilSaludConsulta) > 0 && idpaciente > 0) {
            $("#Main").spin("large");
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'panel-medico/change_member.do',
                    "id=" + idpaciente,
                    function (data) {

                        if (data.result) {

                            window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + data.idpaciente + "-" + data.nombre + "-" + data.apellido + "/registros-consultas-medicas-detalle/" + idperfilSaludConsulta;
                        } else {
                            $("Main").spin(false);
                            x_alert(data.msg);
                        }
                    }
            );




        }

    });

    //boton habilitar un turno declinado
    $(".btnHabilitarTurno").click(function () {
        $element = $(this);
        $modal = $element.parentsUntil(".modal-turnos").last().parent();


        var idturno = $(this).data("idturno");
        if (parseInt(idturno) > 0) {
            //confirmar la accion
            jConfirm({
                title: x_translate("Habilitar turno"),
                text: x_translate("El turno pasará a estar disponible en su agenda. Está seguro de que desea habilitar el turno?"),
                confirm: function () {

                    $modal.spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "habilitar_turno.do",
                            "idturno=" + idturno,
                            function (data) {
                                x_alert(data.msg);
                                $modal.spin(false);
                                if (data.result) {
                                    //recargamos el modulo de la agenda semanal con  el turno actualizado
                                    var fecha = $("#dia_agenda").val();
                                    $modal.modal("hide");
                                    $('#Main').spin("large");
                                    x_loadModule('agenda', 'agenda_diaria', 'fecha=' + fecha + '&idconsultorio=' + $("#idconsultorio").val(), 'agenda_diaria_medico');

                                }
                            }
                    );
                },
                cancel: function () {

                },
                confirmButton: x_translate("Si"),
                cancelButton: x_translate("No")
            });
        }
    });
    // boton para cancelar disponibilidad, este btn tiene el icono del basurero y el de habilitar

    $(".btnCancelarDisponibilidad").click(function (e) {
        e.preventDefault();
        e.stopPropagation();
        
        var idturno = $(this).data("idturno");
        var estado = $(this).data("estado");
        console.log(idturno);
        
        jConfirm({
            title: x_translate("Cambiar disponibilidad"),
            text: x_translate("El turno cambiara su estado. Está seguro que desea realizarlo?"),
            confirm: function () {
                $("body").spin();
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "medico.php?action=1&modulo=agenda&submodulo=cambiar_disponibilidad_turno",
                        "idturno=" + idturno + "&estado=" + estado,
                        function (data) {
                            $("body").spin(false);
                            if (data.result) {
                                //recargamos el modulo del turno
                                x_loadModule('agenda', 'agenda_diaria', 'fecha=' + $("#dia_agenda").val() + '&idconsultorio=' + $("#idconsultorio").val(), 'agenda_diaria_medico').then(function () {
                                    $("body").spin(false);
                                });
                            } else {
                                x_alert(data.msg);
                                $("body").spin(false);
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
});