$(document).ready(function () {
    $("#Main").spin(false);
    renderUI2();
    $(".ce-nc-steps li.ce-nc-step").eq(0).addClass("actual");

    $('.bst-cambiar-pacientes-trigger').on('click', function (e) {
        e.preventDefault();
        $(this).next('.bst-cambiar-pacientes-slide').slideToggle();
        $(this).children('.icon-doctorplus-arrow-down').toggleClass('btn-up-arrow');
    });

    $('.ver-mapa-trigger').on('click', function (e) {


        //Creo el mapa acá, sino con el slide no se ve.. no se inicializa la primera vez
        if ($("#map_canvas_modal .gm-style").length != 1) {

            var ICON_RED = $("#imgs_path").val() + "/icons/ico_pointer_red.png";

            if ($("#lng").val() != "") {

                var lat = $("#lat").val();
                var lng = $("#lng").val();

            } else {

                var lat = -34.6083;
                var lng = -58.3712;
            }

            var latlng = new google.maps.LatLng(lat, lng);

            var myOptions = {
                zoom: 13,
                center: latlng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            };


            //inicializamos el mapa
            map = new google.maps.Map(document.getElementById("map_canvas_modal"), myOptions);

            var infowindow = new google.maps.InfoWindow();
            var bounds = new google.maps.LatLngBounds();

            html_cont = "<div class='' style='top:42px; left:54px;'>" +
                    "<div class='map-tooltip-inner'>" +
                    "<div class='map-content'>" +
                    "<img src='" + $("#img_medico").attr("src") + "' alt='usuario' class='mCS_img_loaded'>" +
                    "<div class='tooltip-usr'>" +
                    $("#titulo_profesional_medico").val() + " " + $("#nombre_apellido_medico").val() +
                    "<span>" + $("#especialidad_medico").val() + "</span>" +
                    "</div>" +
                    "<div class='tooltip-address'>" +
                    "<i class='icon-doctorplus-map-plus-rounded'></i>" +
                    "<p>" +
                    $("#direccion_medico").val() +
                    "</p>" +
                    "</div>" +
                    "</div>" +
                    "<span class='map-tooltip-arrow'></span>" +
                    "</div>" +
                    "</div>";


            infowindow.setContent(html_cont);

            var marker = new google.maps.Marker({
                position: latlng,
                map: map,
                icon: ICON_RED,
                draggable: false,
                title: "Carte des cabinets"
            });

            marker.setIcon(ICON_RED);

            infowindow.open(map, marker);
        }

        e.preventDefault();
        $('#bst-mapa').slideToggle();

    });

    $("#motivovisita_idmotivoVisita").change(function () {
        $("#motivovisita_idmotivoVisita_reservar").val($("#motivovisita_idmotivoVisita").val());
    });

    //desmarcamos los programas que no son ofrecidos por la empresa
    if (ids_excepciones_programa !== "") {
        if (ids_excepciones_programa !== "ALL") {
            ids_excepciones_programa.split(',').forEach(function (id) {
                $(".programa-destacado-tag[data-id=" + id + "]").addClass("hide");
            });
            $(".programa-destacado-tag:not(.hide)").show();
        } else {
            $(".programa-destacado-tag").show();
        }
    }
    //marcamos el programa o categoria seleccionado
    $(".select-programa").click(function (e) {
        e.preventDefault();
        e.stopPropagation();
        let idprograma = $(this).data("idprograma");
        $(".select-programa").not("[data-idprograma=" + idprograma + "]").removeClass("open");
        $(this).toggleClass("open");
    });
    //marcamos el programa o categoria seleccionado
    $(".select-categoria").click(function (e) {
        e.preventDefault();
        $(".item-seleccionado").html("");
        $("#idprograma_categoria").val("");
        $("#idprograma_salud").val("");
        if ($(this).data("idprograma") != "") {
            let idprograma = $(this).data("idprograma");
            $(".item-seleccionado").append($(".nombre-programa[data-idprograma=" + idprograma + "]").clone());
            $("#idprograma_salud").val(idprograma);
        }
        if ($(this).data("idcategoria") != "") {
            let idcategoria = $(this).data("idcategoria");
            $(".item-seleccionado").append($(".nombre-categoria[data-idcategoria=" + idcategoria + "]").clone());
            $("#idprograma_categoria").val(idcategoria);
        }

        $(".label-default").hide();
        $(".item-seleccionado").show();
        updateComboBoxSelect2("#idprograma_categoria", 'motivovisita_idmotivoVisita', 'ManagerMotivoVisita', 'getComboByProgramaCategoria', 0, x_translate('Seleccione una opción'), doUpdateComboBoxSelect2);


    });

    if ($('.bst-cobertura-slide-box').length > 0) {

        $('.tengo-cobertura-trigger').on('click', function (e) {
            e.preventDefault();
            if (!$(this).hasClass('disabled')) {
                $('.cobertura-slide-box-1').slideUp();
                $('.cobertura-slide-box-2').slideDown();
                $('.pago-particular .custom-checkbox').radiocheck('uncheck');
            }
        });

        $('.cobertura-guardar-datos').on('click', function (e) {
            e.preventDefault();
            if (!$(this).hasClass('disabled')) {
                $('.cobertura-slide-box-2').slideUp();
                $('.cobertura-slide-box-3').slideDown();
                $('.pago-particular .custom-checkbox').radiocheck('uncheck');
            }
        });

        $('.cobertura-cambiar-datos').on('click', function (e) {
            e.preventDefault();
            if (!$(this).hasClass('disabled')) {
                $('.cobertura-slide-box-3').slideUp();
                $('.cobertura-slide-box-2').slideDown();
                $('.pago-particular .custom-checkbox').radiocheck('uncheck');
            }
        });


    }

//opciones de checkbox paciente nuevo o exitente
    if ($("#paciente-existente").is(':checked')) {
        $("#visitaPrevia_reservar").val(1);
    }
    if ($("#paciente-nuevo").is(':checked')) {
        $("#visitaPrevia_reservar").val(0);
    }

    $("#paciente-existente").click(function () {
        if ($(this).is(':checked')) {
            $("#visitaPrevia_reservar").val(1);
        }
    });

    $("#paciente-nuevo").click(function () {
        if ($(this).is(':checked')) {
            $("#visitaPrevia_reservar").val(0);
        }
    });

//acciones del checkbox de pagar en forma particular
//habilitar/deshabilirar opciones obra social
    $('.pago-particular .custom-checkbox').on('click', function (e) {

        if ($(this).is(':checked')) {
            $("#planObraSocial_idplanObraSocial_reservar").val("");
            $("#obraSocial_idobraSocial_reservar").val("");
            $("#particular_reservar").val(1);

            if ($('.cobertura-slide-box-3').is(':visible')) {
                $('.cobertura-data-list').addClass('disabled');
                $('.pago-particular .custom-checkbox').toggle('check');
            }
            if ($('.cobertura-slide-box-2').is(':visible')) {
                $('.cobertura-slide-box-2').slideUp();
                $('.cobertura-slide-box-1').slideDown();
                $('.pago-particular .custom-checkbox').radiocheck('check');
            }

            $('.cobertura-btn').addClass('disabled');
        } else {

            $("#planObraSocial_idplanObraSocial_reservar").val($("#planObraSocial_idplanObraSocial").val());
            $("#obraSocial_idobraSocial_reservar").val($("#idobraSocial").val());
            $('.cobertura-data-list').removeClass('disabled');
            $("#particular_reservar").val(0);
            if ($('.cobertura-btn').hasClass('disabled')) {
                $('.cobertura-btn').removeClass('disabled');
            }
        }
    });


    $(".change_paciente_turno").click(function () {
        id = $(this).data("id");
        if (parseInt(id) > 0) {
            $(".div_info_paciente_turno").hide();
            $("#info_paciente_turno_" + id).show();
            $('.bst-cambiar-pacientes-trigger').click();
            $("#idpaciente_obra_social").val(id);
            $("#paciente_idpaciente_reservar").val(id);
            getDatosPaciente();
        }
    });


//funcion que obtiene un JSON y actualiza los datos de obra social cuando se carga la pagina o cambian los datos de cobertura 
    var getDatosPaciente = function () {
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'get_informacion_paciente.do',
                'idpaciente=' + $("#paciente_idpaciente_reservar").val() + "&idmedico=" + $("#idmedico_reservar").val(),
                function (data) {

                    //si tiene cobertura seteamos los datos
                    if (data.hasOwnProperty("idobraSocialPaciente")) {

                        $("#p_obra_social").html(data.nombre + " (" + data.nombre + ")");
                        $("#p_plan_obra_social").html(data.nombrePlan);
                        $("#p_numero_afiliado").html(data.nroAfiliadoObraSocial);
                        $(".cobertura-slide-box-3").show();
                        $(".cobertura-slide-box-1").hide();
                        $(".cobertura-slide-box-2").hide();
                        $('.pago-particular .custom-checkbox').radiocheck('uncheck');
                        $(".cobertura-btn").removeClass('disabled');
                        $('.cobertura-data-list').removeClass('disabled');
                        $("#particular_reservar").val(0);
                        $("#obraSocial_idobraSocial_reservar").val(data.obraSocial_idobraSocial);
                        $("#planObraSocial_idplanObraSocial_reservar").val(data.planObraSocial_idplanObraSocial);

                    } else {//sino seteamos la opcion de pagar en forma particular
                        $("#particular_reservar").val(1);
                        $("#obraSocial_idobraSocial_reservar").val("");
                        $("#planObraSocial_idplanObraSocial_reservar").val("");
                        $(".cobertura-slide-box-1").show();
                        $(".cobertura-slide-box-2").hide();
                        $(".cobertura-slide-box-3").hide();
                        $('.pago-particular .custom-checkbox').radiocheck('check');
                        $(".cobertura-btn").addClass('disabled');
                    }
                    if (data.hasOwnProperty("is_frecuente") && data.is_frecuente) {
                        $("#paciente-existente").radiocheck("check");
                        $("#paciente-nuevo").prop("disabled", true);
                        $("#visitaPrevia_reservar").val(1);
                    } else {
                        $("#paciente-nuevo").radiocheck("check");
                        $("#paciente-nuevo").prop("disabled", false);
                        $("#visitaPrevia_reservar").val(0);
                    }
                }
        );
    };
//obtenemos los datos de OS cuando se carga la pagina
    getDatosPaciente();

//aciones autosugges obra social
    $("#idobraSocial").change(function () {
        updateComboBox("#idobraSocial", 'planObraSocial_idplanObraSocial', 'ManagerPlanesObrasSociales', 'getCombo', 0, 'Plan', doUpdateComboBoxSelect2);
    });

    $('#as_obra_social').autocomplete({
        zIndex: 10000,
        serviceUrl: BASE_PATH + 'paciente_p.php?action=1&modulo=turno&submodulo=obrasocial_autosuggest',
        onSelect: function (data) {
            if (data.data) {
                $("#idobraSocial").val(data.data).change();
            }
        }
    }).on('keyup, blur', function () {
        if (this.value == "") {
            $("#idobraSocial").val("").change();
        }
    });

//guardar cambios en la cobertura medica
    $("#cobertura-guardar-datos").click(function () {

        $("#cobertura_plan").spin("large");
        x_sendForm($('#cobertura_plan'), true, function (data) {
            $("#cobertura_plan").spin(false);
            x_alert(data.msg);
            getDatosPaciente();
        });
    });

//si se selecciona una obra social seteamos los id de la misma
    if ($("#particular_reservar").val() == 0) {
        $("#obraSocial_idobraSocial_reservar").val($("#idobraSocial").val());
        $("#planObraSocial_idplanObraSocial_reservar").val($("#planObraSocial_idplanObraSocial").val());

    } else {//si se selecciona pagar de forma particular limpio la informacion de OS
        $('.cobertura-data-list').addClass('disabled');
        $('.cobertura-btn').addClass('disabled');
        $("#planObraSocial_idplanObraSocial_reservar").val("");
        $("#obraSocial_idobraSocial_reservar").val("");
        $("#particular_reservar").val(0);

    }



    $("#btn_reservar").click(function () {

        if ($("#motivovisita_idmotivoVisita_reservar").val() == "") {
            x_alert(x_translate("Seleccione motivo de visita"));
            return false;
        }


        if ($("#text-msg").val().length === 0) {
            x_alert(x_translate("Ingresa el texto de la consulta con el mayor detalle posible para una respuesta más rápida y precisa."));
            $("#text-msg").addClass("select-required");
            return false;
        }

        //carga de imagenes en proceso
        if ($("#dropzone .dz-complete").length !== $("#dropzone .dz-preview").length) {
            x_alert(x_translate("Aguarde mientras se cargan los archivos adjuntos"));
            return false;

        }


        $("#Main").spin("large");
        x_sendForm($('#reservar_turno'),
                true,
                function (data) {

                    if (data.result) {
                        x_doAjaxCall(
                                'POST',
                                BASE_PATH + 'confirmar_turno.do',
                                'id=' + $("#idturno").val(),
                                function (data) {

                                    if (data.result) {
                                        x_loadModule('turno', 'sacar_turno_step_3', 'turno=' + $("#idturno").val(), 'Main', BASE_PATH + "paciente_p").then(function () {
                                            $("#Main").spin(false);
                                        });
                                    } else {
                                        $("#Main").spin(false);
                                        x_alert(data.msg);
                                    }

                                }
                        );
                    } else {
                        $("#Main").spin(false);
                        x_alert(data.msg);
                    }
                });
    });


    $("#btnCancelar").click(function () {
        $("#Main").spin("large");
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'cancelar_from_creacion.do',
                'id=' + $("#idturno_reservar").val(),
                function (data) {
                    $("#Main").spin(false)
                    if (data.result) {
                        window.location.href = BASE_PATH + "panel-paciente/busqueda-profesional/";
                    } else {
                        x_alert(data.msg);
                    }
                }
        );
    });


});