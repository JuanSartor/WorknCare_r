$(function() {

    /// scroll
    $('#modulo_listado_consultorios').on('click', '.pbn-turnos-holder .a_semana_next,.pbn-turnos-holder .a_semana_previous,.pbn-turnos-holder .a_semana_next_turno', function() {

        $this = $(this);
        //Div que tiene la data del consultorio, médico y semana
        $div_with_data = $this.parents(".pbn-turnos-holder");
        var semana;
        if ($this.hasClass("a_semana_next")) {
            semana = "&week=next";
        }
        else if ($this.hasClass("a_semana_previous")) {
            semana = "&week=previous";
        }
        else {
            semana = "&diferencia_semanas=" + $this.data("cantidad_semanas");
        }

        $("#div_busqueda_agenda_semanal_medico_" + $div_with_data.data("idconsultorio")).spin("large");
        x_loadModule("busqueda",
                "busqueda_agenda_semanal_medico",
                "idmedico=" + $div_with_data.data("idmedico") + "&idconsultorio=" + $div_with_data.data("idconsultorio_to_change")
                + semana + "&fecha=" + $div_with_data.data("fecha") + "&idconsultorio_contenedor=" + $div_with_data.data("idconsultorio"),
                "div_busqueda_agenda_semanal_medico_" + $div_with_data.data("idconsultorio"), BASE_PATH + "paciente_p");
    });


    var altoUl = 230;

     //boton setear o eliminar medico favorito
    $('#modulo_listado_consultorios').on('click', '.agregar_favoritos', function(e) {
        $element = $(this);
        var id = $(this).data('id');
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'marcar_favorito.do',
                'idmedico=' + id,
                function(data) {
                    if (data.result) {
                        $element.toggleClass('selected');
                    } else {
                        x_alert(data.msg);
                    }
                }
        );
    });


    $('#modulo_listado_consultorios').on('click', '.pbn-turnos-holder .pbn-mas-trigger', function(e) {
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


    $('.pbn-mas-trigger').on('click', function(e) {



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


    if ($('.pbn-static-btn').length > 0) {

        var headerHeight = $('#menu').height() + 50;
        var elepos = $('.pbn-static-btn').offset().top;
        var topspace = elepos - headerHeight;




        $(window).on('scroll', function() {
            // Add by seba: Disparo el evento AjustarMAPA para inicializar el contenedor de los elementos que se utilizan en el mapa			
            ajustarMapaBuscador();

        });
    }

//evento para desplegar las intrucciones de 'Como funciona' en version movil
    $('#pbn-instrucciones-btn, .pbr-instrucciones-trigger').on('click', function(e) {
        e.preventDefault();
        $('#pbr-instrucciones').fadeToggle();
    });


	// Codigo 
	// Inicialización de los checks
    $(':checkbox').radiocheck();


    $("#modulo_listado_consultorios").on('click', '.change_consultorio', function() {
        
        if($(this).hasClass("virtual")){
            $("#msg_consulta_reintegro").show();
        }else{
            $("#msg_consulta_reintegro").hide();
        }
        
        $div_with_data = $("#pbn-turnos-holder-" + $(this).data("idconsultorio"));
        $("#pbn-turnos-holder-" + $(this).data("idconsultorio")).data("idconsultorio_to_change", $(this).data("idconsultorio_to_change"));

        $("#div_busqueda_agenda_semanal_medico_" + $(this).data("idconsultorio")).spin("large");
        x_loadModule("busqueda",
                "busqueda_agenda_semanal_medico",
                "idmedico=" + $(this).data("idmedico") + "&idconsultorio=" + $(this).data("idconsultorio_to_change")
                + "&fecha=" + $div_with_data.data("fecha") + "&idconsultorio_contenedor=" + $div_with_data.data("idconsultorio"),
                "div_busqueda_agenda_semanal_medico_" + $div_with_data.data("idconsultorio"), BASE_PATH + "paciente_p");
    });


  
});

    