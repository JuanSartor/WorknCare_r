$(function () {


    $('.td-tooltip-btn').tooltipster({
        theme: 'tooltipster-light'
    });

//cambiar estado del turno
    $(".btnCambiarEstadoTurno").click(function () {
        var estado = $(this).data("estado");
        if (estado == 1) {
            var txt = x_translate("Está seguro de que desea confirmar el turno?");
        } else if (estado == 2) {
            var txt = x_translate("Está seguro de que desea cancelar el turno?");
        } else if (estado == 3) {
            var txt = x_translate("Está seguro de que desea declinar el turno?");
        } else if (estado == 5) {
            var txt = x_translate("Está seguro de que desea marcar al paciente como Ausente?");
        } else {
            return false;
        }

        jConfirm({
            title: x_translate("Cambiar estado"),
            text: txt,
            confirm: function () {
                $(".td-slide-holder").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + "cambiar_turno.do",
                        "idturno=" + $("#idturno").val() + "&estado=" + estado,
                        function (data) {
                            $(".td-slide-holder").spin(false);
                            if (data.result) {
                                if (estado != 2) {

                                    x_alert(data.msg, function () {

                                        recargar(BASE_PATH + "panel-medico/agenda/detalle-turno-" + $("#idturno").val() + ".html");
                                    });
                                } else {
                                    x_alert(data.msg, function () {

                                        recargar(BASE_PATH + "panel-medico/agenda/");
                                    });
                                }
                            } else {
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

    //boton habilitar un turno declinado
    $(".btnHabilitarTurno").click(function () {

        var idturno = $(this).data("idturno");
        if (parseInt(idturno) > 0) {
            //confirmar la accion
            jConfirm({
                title: x_translate("Habilitar turno"),
                text: x_translate('El turno pasará a estar disponible en su agenda. Está seguro de que desea habilitar el turno?'),
                confirm: function () {

                    $(".td-slide-holder").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "habilitar_turno.do",
                            "idturno=" + idturno,
                            function (data) {


                                if (data.result) {
                                    //recargamos el modulo de la agenda semanal con  el turno actualizado
                                    x_alert(data.msg, function () {
                                        recargar(BASE_PATH + "panel-medico/agenda/agenda-semanal/");
                                    });
                                } else {
                                    $(".td-slide-holder").spin(false);
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
        }
    });

    //boton escribir conclusiones en PerfilSaludConsulta
    $(".btnEscribirConclusiones").click(function () {
        var idturno = $(this).data("idturno");
        var idpaciente = parseInt($(this).data("idpaciente"));

        if (parseInt(idturno) > 0 && idpaciente > 0) {
            $(".td-slide-holder").spin("large");
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'panel-medico/change_member.do',
                    "id=" + idpaciente,
                    function (data) {

                        if (data.result) {
                            window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + data.idpaciente + "-" + data.nombre + "-" + data.apellido + "/consultanueva.html?idturno=" + idturno;
                        } else {
                            $(".td-slide-holder").spin(false);
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
            $(".td-slide-holder").spin("large");
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'panel-medico/change_member.do',
                    "id=" + idpaciente,
                    function (data) {

                        if (data.result) {

                            window.location.href = BASE_PATH + "panel-medico/mis-pacientes/" + data.idpaciente + "-" + data.nombre + "-" + data.apellido + "/registros-consultas-medicas-detalle/" + idperfilSaludConsulta;
                        } else {
                            $(".td-slide-holder").spin(false);
                            x_alert(data.msg);
                        }
                    }
            );




        }

    })


    //mover a los siguinetes turnos
    $("#btnTurnoPrevio,#btnTurnoSiguiente").click(function () {
        var idturno = $(this).data("idturno");

        if (parseInt(idturno) > 0) {

            $(".td-slide-holder").spin("large");
            x_loadModule('turno', 'turno_detalle', 'id=' + idturno, 'div_turno_detalle', BASE_PATH + "medico");
        }
    });



    $('.td-turno-datos-paciente-trg').on('click', function (e) {
        e.preventDefault();


        $(this).next('.td-turno-datos-paciente-collapse').slideToggle(function () {

            $slider = $('.td-slide-box');

            $slider.find(".slick-slide").height("auto");
            $slider.slick("setOption", '', '', true);

        });
        $(this).find('.arrow').toggleClass('rotate');


    })


    $('.td-slide-box').slick({
        dots: false,
        infinite: true,
        speed: 300,
        arrows: true,
        autoplay: false,
        autoplaySpeed: 8000,
        adaptiveHeight: true,
        pauseOnFocus: true,
        pauseOnHover: true,
        pauseOnDotsHover: true,
        adaptiveHeight: false
    });


    $('.td-slide-box').on('afterChange', function (event, slick, currentSlide) {
        $slider = $('.td-slide-box');

        $slider.find(".slick-slide").height("auto");
        $slider.slick("setOption", 'adaptiveHeight', true, true);
    });

    $('.td-slide-arrow.left').on('click', function (e) {
        e.preventDefault();
        $('.td-slide-box').slick('slickPrev');
    });

    $('.td-slide-arrow.right').on('click', function (e) {
        e.preventDefault();
        $('.td-slide-box').slick('slickNext');
    });



    $('.td-slide-box').on('afterChange', function (event, slick, direction) {
        if ($('.td-swipe-icon').is(':visible')) {
            $('.td-swipe-icon').hide();
        }
    });



    $('.td-tooltip-btn').on('click', function (e) {
        e.preventDefault();
        $('.td-tooltip-btn').tooltipster('open');
    });






});



		