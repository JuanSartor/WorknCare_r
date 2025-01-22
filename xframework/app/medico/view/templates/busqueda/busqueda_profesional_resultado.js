$(function() {
$("#Main").spin("large");
	// Atachamos evento al resize del browser
    $(window).resize(function() {
      
        resize();

        // Add by seba: Disparo un resise sobre el mapa para que se acomode al cambio de tamaño del contendor
        if (mapa_inicializado) {
            google.maps.event.trigger(map, "resize");
        }
        ajustarMapaBuscador();

    });
	
	// Inicializamos la pantalla y llamamos a la función resize para que calcule los tamaños
    $(window).load(function() {
        //console.log("LOAD");
        resize();
    });

	/**
	*
	* Funcion que ajusta la ventana del mapa según el scroll y las resoluciones.
	*
	*/
    var ajustarMapaBuscador = function() {

        var currentTop = $(window).scrollTop();
        var currentElePos = $('.pbn-static-btn').offset().top;
        var currentElePosH = $('.pbn-static-btn').offset().left;
        var btnposV = currentElePos - currentTop;

		$("#map_canvas").css({
			width: actual_w,
			height: actual_h
		})


        if (currentTop > topspace) {
            // Add by seba: Si estoy  por debajo de la linea de corte del boton
            $("#pbn-map").css({
                width: actual_w,
                height: actual_h
            });
						
            if (!$('.pbn-static-btn').hasClass('rounded')) {

                $('.pbn-static-btn').addClass('rounded');
                $('.pbn-static-btn').css({
                    position: 'fixed',
                    top: 120,
                    right: '5%',
                    'z-index': 9000
                });

                // Add by seba: Actualizo el tamaño de los contenedores en base al tamaño de pantalla
                $("#pbn-map").css({
                    position: 'fixed',
                    top: 104,
                    left: 0,
                    width: actual_w,
                    height: actual_h

                });
                $("#map_canvas").css({
                    width: actual_w,
                    height: actual_h
                });

                // Add by seba: Disparo un resise sobre el mapa para que se acomode al cambio de tamaño del contendor
               if(mapa_inicializado){
                    google.maps.event.trigger(map, "resize");
               }
               

            }

        } else if (currentTop < topspace) {

			$("#map_canvas").css({
				width: $('.okm-container').width(),
				height: actual_h,
			});
            // Si estoy por encima de la linea de corte del botón
            $("#pbn-map").css({
                position: 'absolute',
                top: 0,
                left: "-20px",
                width: $('.okm-container').width(),
                height: actual_h
            });
            if ($('.pbn-static-btn').hasClass('rounded')) {
                $('.pbn-static-btn').removeClass('rounded');
                $('.pbn-static-btn').css({
                    position: 'relative',
                    top: 0,
                    left: 'inherit',
                    'z-index': 1
                });

                // Add by seba: Actualizo el tamaño de los contenedores en base al tamaño de pantalla
                $("#pbn-map").css({
                    position: 'absolute',
                    top: 0,
                    left: 0,
                    width: $('.okm-container').width(),
                    height: actual_h
                });

                $("#map_canvas").css({
                    width: $('.okm-container').width(),
                    height: actual_h,
                });

            }
        }
    }

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
            $(this).html('Menos');
        } else {
            innerSlide.animate({
                height: altoUl
            }, 600);
            $(this).html('Más...');
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
            $(this).html('Menos');
        } else {
            innerSlide.animate({
                height: altoUl
            }, 600);
            $(this).html('Más...');
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


    $('#pbn-instrucciones, .pbr-instrucciones-trigger').on('click', function(e) {
        e.preventDefault();
        $('#pbr-instrucciones').fadeToggle();
    });


    $('#pbn-instrucciones, .pbr-instrucciones-trigger').on('click', function(e) {
        e.preventDefault();
        $('#pbr-instrucciones').fadeToggle();
    });

    $('.pbn-map-trigger').on('click', function(e) {
        e.preventDefault();


        // Add by seba: Inicializo el contenedor del mapa
        $("#pbn-map").css({
            width: $('.okm-container').width(),
            height: actual_h,
            left: "-20px"
        });
        $("#map_canvas").css({
            width: $('.okm-container').width(),
            height: actual_h,
        });
         ajustarMapaBuscador();

        if (!mapa_inicializado) {
            inicializarMapaBuscador();
        }

        
          
//		$('html, body').animate({
//			scrollTop: $(".pbn-map-holder").offset().top -100
//		}, 1000);
        $('#pbn-map').slideToggle();
    });




	// Codigo 
	// Inicialización de los checks
    $(':checkbox').radiocheck();


    $("#modulo_listado_consultorios").on('click', '.change_consultorio', function() {
        $div_with_data = $("#pbn-turnos-holder-" + $(this).data("idconsultorio"));
        $("#pbn-turnos-holder-" + $(this).data("idconsultorio")).data("idconsultorio_to_change", $(this).data("idconsultorio_to_change"));

        $("#div_busqueda_agenda_semanal_medico_" + $(this).data("idconsultorio")).spin("large");
        x_loadModule("busqueda",
                "busqueda_agenda_semanal_medico",
                "idmedico=" + $(this).data("idmedico") + "&idconsultorio=" + $(this).data("idconsultorio_to_change")
                + "&fecha=" + $div_with_data.data("fecha") + "&idconsultorio_contenedor=" + $div_with_data.data("idconsultorio"),
                "div_busqueda_agenda_semanal_medico_" + $div_with_data.data("idconsultorio"), BASE_PATH + "medico");
    });


    $("#tagsinput").on('beforeItemRemove', function(event) {
        var delete_item = event.item.clave;
$("#Main").spin("large");
        if (delete_item != "") {

            x_loadModule("busqueda",
                    "busqueda_profesional_resultado_modulo",
                    "delete_item=" + delete_item,
                    "modulo_listado_consultorios", 
                    BASE_PATH + "medico");
        }
    });
    
    
    x_loadModule("busqueda",
                    "busqueda_profesional_resultado_modulo",
                    "do_reset=1",
                    "modulo_listado_consultorios", 
                    BASE_PATH + "medico");
});

    