$(function () {

    var guardar_reserva = function (tipo, id) {
        console.log("tipo reserva:" + tipo + "-id:" + id);

        //limpiamos el resto de las variables
        sessionStorage.removeItem('tipo_reserva');
        sessionStorage.removeItem('idreserva');
        sessionStorage.setItem('tipo_reserva', tipo);
        sessionStorage.setItem('idreserva', id);

        //cargamos el login
        $("#loginbtn").trigger("click");
    };

    //comportamiento boton consulta presencial y videoconsulta turno ->lleva al listado de turnos en la parte inferior
    $(".sacar-turno-presencial,.sacar-turno-vc").click(function () {
        var target = ".pbp-turno-header." + $(this).data("target");
        console.log("Scroll horarios:", target);
        if ($(target).length > 0) {
            scrollToEl($(target));
        }
    });

    //click boton en agenda sin turno  link para hacer vc/ce inmediata
    $("#modulo_listado_consultorios").on("click", ".no-turno-select-profesional-frecuente-vc", function () {
        $(".select-profesional-frecuente-vc").trigger("click");
    });
    $("#modulo_listado_consultorios").on("click", ".no-turno-select-profesional-frecuente-ce", function () {
        $(".select-profesional-frecuente-ce").trigger("click");
    });

    //medico ofrece consulta solo a sus pacientes
    $(".consultaexpress_solo_pacientes").on("click", function (e) {
        e.preventDefault();
        var idmedico = $(this).data('id');
        if (parseInt(idmedico) > 0) {
            guardar_reserva("consultaexpress", idmedico);
        }
    });
    $(".videoconsulta_solo_pacientes").on("click", function (e) {
        e.preventDefault();
        var idmedico = $(this).data('id');
        if (parseInt(idmedico) > 0) {
            guardar_reserva("videoconsulta", idmedico);
        }
    });


    //botones para crear la consulta asociada a un medico
    $(".pbp-planes-item").click(function () {
        //consulta express
        var elem_ce = $(this).find(".select-profesional-frecuente-ce");
        if (elem_ce.length > 0) {
            var idmedico = elem_ce.data('id');

            if (parseInt(idmedico) > 0) {
                guardar_reserva("consultaexpress", idmedico);
            }
        }
        //videoconsulta
        var elem_vc = $(this).find(".select-profesional-frecuente-vc");

        if (elem_vc.length > 0) {
            var idmedico = elem_vc.data('id');
            if (parseInt(idmedico) > 0) {
                guardar_reserva("videoconsulta", idmedico);
            }
        }


    });

    //verficamos si el turno sigue disponible al hacer click
    $('#modulo_listado_consultorios').on("click", "a.a_reservar_turno", function (e) {
        console.log("reservar turno");

        e.preventDefault();
        var idturno = $(this).data('idturno');
        if (parseInt(idturno) > 0) {

            guardar_reserva("turno", idturno);
        }
    });
    $('#modulo_listado_consultorios').on("click", "a.a_reservar_turno_vc", function (e) {
        console.log("reservar turno");

        e.preventDefault();
        var idturno = $(this).data('idturno');
        if (parseInt(idturno) > 0) {

            guardar_reserva("turno_vc", idturno);
        }
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
    var vpw = $(window).width() + getScrollBarWidth();
    if (vpw <= 800) {

        $('.pbp-card').find('h3').on('click', function (e) {
            $(this).next('.pbp-card-slide').slideToggle(function () {


            });
            $(this).toggleClass('selected');
        });
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
                "div_busqueda_agenda_semanal_medico_" + $div_with_data.data("idconsultorio"), BASE_PATH + "frontend_2");
    });

    //delegacion eventos - ver mas turnos
    var altoUl = 230;
    $('#modulo_listado_consultorios').on('click', '.pbn-turnos-holder .pbn-mas-trigger', function (e) {
        e.preventDefault();

        var innerSlide = $(this).parent('.pnb-slide-col');
        var heightSlide = $(this).parent('.pnb-slide-col').children('ul').outerHeight() + $(this).outerHeight();

        if (innerSlide.outerHeight() <= altoUl) {



            innerSlide.animate({
                height: heightSlide
            }, 600);
            $(this).html('Moins');
        } else {
            innerSlide.animate({
                height: altoUl
            }, 600);
            $(this).html('Plus...');
        }
    });

});
        