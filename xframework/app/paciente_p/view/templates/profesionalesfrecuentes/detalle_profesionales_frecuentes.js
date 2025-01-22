$(function () {
    //comportamiento boton consulta presencial y videoconsulta turno ->lleva al listado de turnos en la parte inferior
    $(".sacar-turno-presencial,.sacar-turno-vc").click(function () {
        var target = ".pbp-turno-header." + $(this).data("target");
        console.log("Scroll horarios:", target);
        if ($(target).length > 0) {
            scrollToEl($(target));
        }
    });

    /*$("#btnCargarCredito").click(function () {
     localStorage.setItem('payment_redirect', 'turno_vc:' + $(this).data("idturno"));
     var monto_compra = $(this).data("monto-compra");
     window.location.href = BASE_PATH + "panel-paciente/credito-proceso-compra/?compra=" + monto_compra;
     });*/
    //medico ofrece consulta solo a sus pacientes
    $(".consultaexpress_solo_pacientes").on("click", function (e) {
        e.preventDefault();
        x_alert(x_translate("Este profesional solo ofrece servicios de Consulta Express a sus pacientes frecuentes"));
    });
    $(".videoconsulta_solo_pacientes").on("click", function (e) {
        e.preventDefault();
        x_alert(x_translate("Este profesional solo ofrece servicios de Video Consulta a sus pacientes frecuentes"));
    });

    //botones para crear la consulta asociada a un medico
    $(".pbp-planes-item").click(function () {
        //consulta express
        var elem_ce = $(this).find(".select-profesional-frecuente-ce");
        if (elem_ce.length > 0) {
            var idmedico = elem_ce.data('id');

            if (parseInt(idmedico) > 0) {
                $("body").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'set_medico_consultaexpress.do',
                        'medico_idmedico=' + idmedico,
                        function (data) {

                            if (data.result) {
                                window.location.href = BASE_PATH + "panel-paciente/consultaexpress/nuevaconsulta.html?continue=true";
                            } else {
                                $("body").spin(false);
                                x_alert(data.msg);
                            }

                        }

                );
            }
        }
        //videoconsulta
        var elem_vc = $(this).find(".select-profesional-frecuente-vc");

        if (elem_vc.length > 0) {
            var idmedico = elem_vc.data('id');
            if (parseInt(idmedico) > 0) {
                $("body").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'set_medico_videoconsulta.do',
                        'medico_idmedico=' + idmedico,
                        function (data) {

                            if (data.result) {
                                window.location.href = BASE_PATH + "panel-paciente/videoconsulta/nuevavideoconsulta.html?continue=true";
                            } else {
                                $("body").spin(false);
                                x_alert(data.msg);
                            }

                        }

                );
            }
        }


    });

    //boton setear o eliminar medico favorito
    $('a.ratting-like').click(function () {
        $element = $(this);
        var id = $(this).data('id');
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'marcar_favorito.do',
                'idmedico=' + id,
                function (data) {
                    if (data.result) {
                        if ($element.hasClass('selected')) {
                            $element.removeClass("selected");
                            $("span.agregar-favorito").show();
                            $("span.eliminar-favorito").hide();
                        } else {
                            $element.addClass("selected");
                            $("span.agregar-favorito").hide();
                            $("span.eliminar-favorito").show();
                        }


                    } else {
                        x_alert(data.msg);
                    }
                }

        );
    });

    $(':checkbox').radiocheck();


    $('.pbn-turnos-slide-holder').on('init', function (slick) {
        //slickNext

        $(this).siblings('.pbn-turnos-right-arrow').on('click', function (e) {
            e.preventDefault();
            $(this).siblings('.pbn-turnos-slide-holder').slick('slickNext');

        });

        $(this).siblings('.pbn-turnos-left-arrow').on('click', function (e) {
            e.preventDefault();
            $(this).siblings('.pbn-turnos-slide-holder').slick('slickPrev');

        });



    });

    $('.pbn-turnos-slide-holder').slick({
        dots: false,
        infinite: true,
        speed: 300,
        slidesToShow: 1,
        adaptiveHeight: false,
        arrows: false
    });

    var altoUl = 230;

    $('.pbn-map-trigger').on('click', function (e) {
        e.preventDefault();

        $('html, body').animate({
            scrollTop: $(".pbn-map-holder").offset().top - 100
        }, 1000);
        $('#pbn-map').slideToggle();
    });

    //animacion de las tarifas de consultas
    $('.pbp-planes-btn').on('click', function (e) {
        e.preventDefault();
        $(this).closest('.gnlist-ratting-holder').prev('.pbp-planes-row').slideToggle();
    });



    $('.pbp-planes-item').on('click', function (e) {
        e.preventDefault();

        var rippleElement = '<span class="okm-ripple"></span>';
        var parentOffset = $(this).offset();
        var relX = e.pageX - parentOffset.left;
        var relY = e.pageY - parentOffset.top;

        var lnk = $(this).attr('href');

        $(rippleElement).remove();

        $(rippleElement).appendTo($(this));
        var ripleIn = $(this).find('.okm-ripple');

        ripleIn.css({
            top: relY + "px",
            left: relX + "px",
            width: "1px",
            height: "1px",
            opacity: "0.5"
        }).show();
        ripleIn.velocity({
            width: "+=400px",
            height: "+=400px",
            top: "-=200px",
            left: "-=200px",
            opacity: 0
        },
                {
                    duration: "slow",
                    queue: false,
                    easing: "easeOutSine",
                    complete: function (elements) {
                        $(elements).remove();
                        window.location.href = lnk;
                    }
                }
        );

    });

    if ($('.pbn-static-btn').length > 0) {

        var headerHeight = $('#menu').height() + 50;
        var elepos = $('.pbn-static-btn').offset().top;
        var topspace = elepos - headerHeight;





        $(window).on('scroll', function () {
            var currentTop = $(window).scrollTop();
            var currentElePos = $('.pbn-static-btn').offset().top;
            var currentElePosH = $('.pbn-static-btn').offset().left;
            var btnposV = currentElePos - currentTop;


            if (currentTop > topspace) {

                if (!$('.pbn-static-btn').hasClass('rounded')) {

                    $('.pbn-static-btn').addClass('rounded');
                    $('.pbn-static-btn').css({
                        position: 'fixed',
                        top: 120,
                        right: '5%',
                        'z-index': 9000
                    });

                    $("#pbn-map").css({
                        position: 'fixed',
                        top: 104,
                        left: 0,
                        width: '100%'
                    });
                }

            } else if (currentTop < topspace) {
                if ($('.pbn-static-btn').hasClass('rounded')) {
                    $('.pbn-static-btn').removeClass('rounded');
                    $('.pbn-static-btn').css({
                        position: 'relative',
                        top: 0,
                        left: 'inherit',
                        'z-index': 1

                    });
                    $("#pbn-map").css({
                        position: 'absolute',
                        top: 0,
                        left: 0
                    });
                }
            }

        });
    }

    function verMasTexto(trigger, obj, inner, height) {

        var animateObj = trigger.prev(obj);
        var innerObj = animateObj.children(inner);

        var altoIni = height;
        var altoSlide = innerObj.outerHeight();



        if (animateObj.outerHeight() <= altoIni) {

            animateObj.animate({
                height: altoSlide
            }, 600);
            trigger.html('Moins');
        } else {
            animateObj.animate({
                height: altoIni
            }, 600);
            trigger.html('Plus...');
        }


    }

    function getHeightText(trigger, obj, inner, height) {

        $.each(trigger, function (i, val) {

            var animateObj = $(this).prev(obj);
            var innerObj = animateObj.children(inner);

            var altoIni = height;
            var altoSlide = innerObj.outerHeight();


            if (altoSlide <= altoIni) {
                $(this).hide();

            }

        });



    }


    if ($('.pbp-medico-ficha').length > 0) {

        getHeightText($('.pbp-ver-mas-trigger'), '.pbp-perfil-profesional-expand-text', '.pbp-perfil-profesional-expand-text-inner', 100);

        $('.pbp-ver-mas-trigger').on('click', function (e) {
            e.preventDefault();
            verMasTexto($(this), '.pbp-perfil-profesional-expand-text', '.pbp-perfil-profesional-expand-text-inner', 100);

        });
    }

    var vpw = $(window).width() + getScrollBarWidth();
    if (vpw <= 800) {

        $('.pbp-card').find('h3').on('click', function (e) {
            $(this).next('.pbp-card-slide').slideToggle(function () {

                if ($(this).is(':visible')) {
                    textcut(".pbp-perfil-profesional-expand-text", $(".pbp-perfil-profesional-expand-text").data('linesrsp'));
                }

            });
            $(this).toggleClass('selected');
        });
    } else {
        textcut(".pbp-perfil-profesional-expand-text", $(".pbp-perfil-profesional-expand-text").data('lines'));
    }


    $('#modulo_listado_consultorios').on('click', '.pbn-turnos-holder .a_semana_next,.pbn-turnos-holder .a_semana_previous,.pbn-turnos-holder .a_semana_next_turno', function () {

        $this = $(this);
        //Div que tiene la data del consultorio, médico y semana
        $div_with_data = $this.parents(".pbn-turnos-holder");
        var semana;
        if ($this.hasClass("a_semana_next")) {
            semana = "&week=next";
        } else if ($this.hasClass("a_semana_previous")) {
            semana = "&week=previous";
        } else {
            semana = "&diferencia_semanas=" + $this.data("cantidad_semanas");
        }

        $("#div_busqueda_agenda_semanal_medico_" + $div_with_data.data("idconsultorio")).spin("large");
        x_loadModule("profesionalesfrecuentes",
                "agenda_semanal_medico",
                "idmedico=" + $div_with_data.data("idmedico") + "&idconsultorio=" + $div_with_data.data("idconsultorio")
                + semana + "&fecha=" + $div_with_data.data("fecha"),
                "div_busqueda_agenda_semanal_medico_" + $div_with_data.data("idconsultorio"), BASE_PATH + "paciente_p");
    });

    //verficamos si el turno sigue disponible al hacer click
    $('#modulo_listado_consultorios').on('click', "a.a_reservar_turno,a.a_reservar_turno_vc", function (e) {
        e.preventDefault();
        var url = $(this).attr("href");
        var idturno = $(this).data("idturno");
        x_doAjaxCall(
                'POST',
                BASE_PATH + "verificar_turno_disponible.do",
                "idturno=" + idturno,
                function (data) {
                    if (data.result) {
                        window.location.href = url;
                    } else {
                        x_alert(data.msg);
                    }
                }

        );
    });

    //click boton en agenda sin turno  link para hacer vc/ce inmediata
    $('#modulo_listado_consultorios').on('click', ".no-turno-select-profesional-frecuente-vc", function () {
        $(".select-profesional-frecuente-vc").trigger("click");
    });
    $('#modulo_listado_consultorios').on('click', ".no-turno-select-profesional-frecuente-ce", function () {
        $(".select-profesional-frecuente-ce").trigger("click");
    });


});