$(function () {
    $("#Main").spin("large");
    $(".btn-volver-home-sante").click(function(e){
        e.preventDefault();
        console.log("mostrar categorias:"+$(this).data("id"));
        x_loadModule("programa_salud","listado_categorias","idprograma_salud="+$(this).data("id"),"Main");
    })
    /// scroll
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
        x_loadModule("busqueda",
                "busqueda_agenda_semanal_medico",
                "idmedico=" + $div_with_data.data("idmedico") + "&idconsultorio=" + $div_with_data.data("idconsultorio_to_change")
                + semana + "&fecha=" + $div_with_data.data("fecha") + "&idconsultorio_contenedor=" + $div_with_data.data("idconsultorio"),
                "div_busqueda_agenda_semanal_medico_" + $div_with_data.data("idconsultorio"), BASE_PATH + "frontend_2");
    });


    var altoUl = 230;

    //boton setear o eliminar medico favorito
    $('#modulo_listado_consultorios').on('click', '.agregar_favoritos', function (e) {
        $element = $(this);
        var id = $(this).data('id');
        $("#loginbtn").trigger("click");
    });


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





    var altoUl = 230;


    $('.pbn-mas-trigger').on('click', function (e) {



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

    // Codigo 
    // Inicialización de los checks
    $(':checkbox').radiocheck();


    $("#modulo_listado_consultorios").on('click', '.change_consultorio', function () {

        if ($(this).hasClass("virtual")) {
            $("#msg_consulta_reintegro").show();
        } else {
            $("#msg_consulta_reintegro").hide();
        }

        $div_with_data = $("#pbn-turnos-holder-" + $(this).data("idconsultorio"));
        $("#pbn-turnos-holder-" + $(this).data("idconsultorio")).data("idconsultorio_to_change", $(this).data("idconsultorio_to_change"));

        //
        //$("#pbn-turnos-holder-" + $(this).data("idconsultorio")).addClass("active");

        $("#div_busqueda_agenda_semanal_medico_" + $(this).data("idconsultorio")).spin("large");
        x_loadModule("busqueda",
                "busqueda_agenda_semanal_medico",
                "idmedico=" + $(this).data("idmedico") + "&idconsultorio=" + $(this).data("idconsultorio_to_change")
                + "&fecha=" + $div_with_data.data("fecha") + "&idconsultorio_contenedor=" + $div_with_data.data("idconsultorio"),
                "div_busqueda_agenda_semanal_medico_" + $div_with_data.data("idconsultorio"), BASE_PATH + "frontend_2");
    });

    x_loadModule("busqueda", "busqueda_profesional_resultado_modulo", "do_reset=1&idprograma_categoria="+$("#idprograma_categoria").val(), "modulo_listado_consultorios", BASE_PATH + "frontend_2");
});

    