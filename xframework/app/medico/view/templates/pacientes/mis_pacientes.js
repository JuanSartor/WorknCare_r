$(document).ready(function () {
    $('[data-toggle="tooltip"]').tooltip();
    $(':checkbox').radiocheck();
    x_loadModule('pacientes', 'mis_pacientes_listado', 'do_reset=1', 'lista-pacientes');
    x_loadModule('pacientes', 'mis_pacientes_sincargo', 'do_reset=1', 'lista-pacientes-sincargo');

    $("#lista-pacientes-sincargo").hide();
// va directo al elemento sin el top
    var scrollToEl = function (trgObj) {
        var trgObjHeight = trgObj.outerHeight();
        $('html, body').animate({
            scrollTop: trgObj.offset().top - 60
        }, 1000);
    };
    //Slider
    $('.btn-slider').on('click', function () {
        var targetId = '#' + $(this).data('target');
        $("#div_container_busqueda").hide();

        $("#div_container_informacion").show();

        if (targetId == "#agregar-paciente") {
            $("#agregar-paciente input:not(:checkbox)").val("");
            $(targetId).slideDown(
                    {done: function () {
                            scrollToEl($(targetId));
                        }
                    });
            $("#lista-pacientes").slideUp();
            $("#lista-pacientes-sincargo").slideUp();
        } else if (targetId == "#lista-pacientes") {
            $(targetId).slideDown(
                    {done: function () {
                            scrollToEl($(targetId));
                        }
                    });
            $("#agregar-paciente").slideUp();
            $("#lista-pacientes-sincargo").slideUp();
        } else if (targetId == "#lista-pacientes-sincargo") {
            $("#agregar-paciente").slideUp();
            $("#lista-pacientes").slideUp();

            $(targetId).slideDown(
                    {done: function () {
                            scrollToEl($(targetId));
                        }
                    });
        } else {
            $(targetId).slideToggle();
            if (targetId != "#opcion-renovacion") {
                $("#opcion-renovacion").slideUp();
            } else {
                $(".opcion-receta").slideUp();
            }
        }
    });


    // boton buscar paciente con icono de lupa
    $("#btnSearchPaciente").click(function () {
        if ($("#buscar_paciente_input").val().length >= 3) {
            $("#cantidad_resultados_input").val("0").change();
            $("#div_container_informacion").hide();
            $("#div_container_busqueda").show();
            $("body").spin("large");
            x_loadModule('pacientes', 'listado_mis_pacientes_busqueda', 'do_reset=1&query_str=' + $("#buscar_paciente_input").val(), 'lista-pacientes-busqueda');
            x_loadModule('pacientes', 'listado_all_pacientes_busqueda', 'do_reset=1&query_str=' + $("#buscar_paciente_input").val(), 'lista-pacientes-full');
        } else {
            $("#buscar_paciente_input").data("title", "Ajoutez au moins 3 lettres").tooltip("show");
        }
    });
    // al presionar enter tambien busco el paciente
    $("#buscar_paciente_input").keypress(function (e) {
        console.log("dsaasd");
        if (e.which == 13) {
            if ($("#buscar_paciente_input").val().length >= 3) {
                $("#cantidad_resultados_input").val("0").change();
                $("#div_container_informacion").hide();
                $("#div_container_busqueda").show();
                $("body").spin("large");
                x_loadModule('pacientes', 'listado_mis_pacientes_busqueda', 'do_reset=1&query_str=' + $("#buscar_paciente_input").val(), 'lista-pacientes-busqueda');
                x_loadModule('pacientes', 'listado_all_pacientes_busqueda', 'do_reset=1&query_str=' + $("#buscar_paciente_input").val(), 'lista-pacientes-full');
            } else {
                x_alert( "Ajoutez au moins 3 lettres");
//                $("#buscar_paciente_input").data("title", "Ajoutez au moins 3 lettres").tooltip("show");
            }

        }
    });

    $("#cantidad_resultados_input").change(function ( ) {
        if (parseInt($(this).val()) == 2) {
            $("#div_sin_registros").show();
        } else {
            $("#div_sin_registros").hide();
        }
    });

    $("#btnSearchPacienteAgregar").click(function () {
        if ($("#buscar_paciente_agregar_input").val().length >= 3) {
            $("body").spin("large");
            $("#div_container_busqueda").show();
            $("#lista-pacientes-busqueda").hide();

            x_loadModule('pacientes', 'listado_all_pacientes_busqueda_agregar', 'do_reset=1&query_str=' + $("#buscar_paciente_agregar_input").val(), 'lista-pacientes-full');
        } else {
            $("#buscar_paciente_agregar_input").data("title", "Ajoutez au moins 3 lettres").tooltip("show");
        }
    });

    $(".date-holder")
            .datetimepicker({
                pickTime: false,
                language: 'fr'
            });



    //$("#invitar_celular").inputmask("9999999999");
    // $("#invitar_dni").inputmask("99999999");

    //agregamos el + al numero de telefono
    $("#invitar_celular").on("keyup", function () {
        if ($(this).val().substring(0, 1) != "+") {
            $(this).val("+" + $(this).val());
        }
    });
    $("#invitar_celular").intlTelInput({
        nationalMode: false,
        preferredCountries: ['fr', 'be', 'lu'],
        utilsScript: BASE_PATH + "xframework/core/libs/libs_js/intl-tel-input/build/js/utils.js"
    });
    $("#invitar_celular").mask("+0000000000000");


    $("#btnEnviarInvitacion").click(function () {

        // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
        $.each($("#invitacion_form input"), function (index, error) {
            var $element = $(error);
            $element.tooltip("destroy");
        });





        if ($("#invitar_apellido").val() == "") {
            $("#invitar_apellido").tooltip("show");
            scrollToEl($("#invitar_apellido"));
            return false;
        }

        if ($("#invitar_email").val() != "" && !validarEmail($("#invitar_email").val())) {
            $("#invitar_email").tooltip("show");
            scrollToEl($("#invitar_email"));
            return false;
        }

        //si hay telefono verifico la longitud


        if ($("#invitar_celular").val() != "") {


            if ($("#invitar_celular").intlTelInput("isValidNumber")) {
                //ok
            } else {
                if ($("#invitar_celular").val().substring(0, 4) == "+337" && ($("#invitar_celular").val().length == 12)) {
                    //ok
                } else {
                    $("#invitar_celular").data("title", x_translate("Ingrese  un número de celular válido")).tooltip("show");
                    scrollToEl($("#telefono_input"));
                    return false;
                }
            }
        }
        $('#invitacion_form').spin("large");
        x_sendForm($('#invitacion_form'), true, function (data) {
            $('#invitacion_form').spin(false);

            if (data.result) {
                //Vacío el formulario
                $("#invitacion_form input:not(:checkbox)").val("");

                $("#span_send_email").html("<a href=\"mailto:" + data.email + "\">" + data.email + "</a>");
                if (data.celular != null) {
                    $("#span_send_cel").html(data.celular);
                    $("#span_send_cel").parent().show();
                }
                $("#text_msg").text(x_translate(data.msg));

                $("#envio_profesionales").modal("show");
                x_loadModule('pacientes', 'invitaciones_pacientes_list', '', 'div_invitaciones_pacientes');
                x_loadModule('pacientes', 'mis_pacientes_listado', 'do_reset=1', 'lista-pacientes');
            } else {
                x_alert(data.msg);
            }
        });
    });


    /*Enviar mensaje a paciente*/
    $('#div_listado_pacientes').on('click', '.btnEnviarMensaje', function () {
        //obtenemos los datos del paciente
        var idpaciente = $(this).data('idpaciente');
        var imagen = $(".container-paciente[data-idpaciente=" + idpaciente + "] .imagen-paciente").first().attr("src");
        var nombre = $(".container-paciente[data-idpaciente=" + idpaciente + "] .nombre-paciente").first().text();

        //seteamos los datos del paciente en el modal
        $("#enviar_mensaje_paciente #imagen_paciente_mensaje").attr("src", imagen);
        $("#enviar_mensaje_paciente #nombre_paciente_mensaje").text(nombre);
        $("#enviar_mensaje_paciente #idpaciente_mensaje").val(idpaciente);
        //mostramos modal
        var targetId = ".enviar_mensaje[data-idpaciente=" + idpaciente + "]";
        $("#enviar_mensaje_paciente").modal("show");
    });




});