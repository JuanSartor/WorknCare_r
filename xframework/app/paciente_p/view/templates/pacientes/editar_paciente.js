$(document).ready(function () {
    scrollToEl($("body"));
    //inicializar plugin numero tel
    $("#telefono_input").intlTelInput({
        nationalMode: false,
        preferredCountries: ['fr', 'be', 'lu'],
        utilsScript: BASE_PATH + "xframework/core/libs/libs_js/intl-tel-input/build/js/utils.js"
    });
    $("#telefono_input").mask("+0000000000000");
    //agregamos el + al numero de telefono
    $("#telefono_input").on("keyup", function () {
        if ($(this).val().substring(0, 1) != "+") {
            $(this).val("+" + $(this).val());
        }
    });

    /**
     * Validación formulario 
     */

    var validar_campos_requeridos_step1 = function () {

        //limpiar viejos tooltips
        $.each($("#frmRegistro input"), function (index, element) {
            var $element = $(element);
            $element.tooltip("destroy").removeClass("select-required");
        });

        $.each($("#frmRegistro select"), function (index, element) {
            var $element = $(element);
            $element.tooltip("destroy").removeClass("select-required");
        });

        /*Validaciones*/

        //validar nombre
        if ($("#nombre_input").val() == "") {
            $("#nombre_input").tooltip("show").addClass("select-required");
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            scrollToEl($("#nombre_input"));
            return false;
        }

        //verificar apellido
        if ($("#apellido_input").val() == "") {
            $("#apellido_input").tooltip("show").addClass("select-required");
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            scrollToEl($("#apellido_input"));
            return false;
        }


        //verificar fecha de nacimiento
        if ($("#fecha_nacimiento").val().length != 10 || (typeof (validatedate) == "function" && !validatedate($("#fecha_nacimiento").val()))) {
            $("#fecha_nacimiento").data("title", x_translate("Ingrese su fecha de nacimiento")).tooltip("show").addClass("select-required");
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            scrollToEl($("#fecha_nacimiento"));
            return false;
        }



        //validar fecha futura
        var time_actual = new Date().getTime();
        var arr_split = $("#fecha_nacimiento").val().split("/");
        var fecha_nac = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
        if (fecha_nac > time_actual) {
            $("#fecha_nacimiento").data("title", x_translate("La fecha de nacimiento no puede ser futura")).tooltip("show").addClass("select-required");
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            scrollToEl($("#fecha_nacimiento"));
            return false;
        }

        //si hay telefono verifico la longitud


        if ($("#telefono_input").val() == "") {

            $("#telefono_input").data("title", x_translate("Ingrese  un número de celular válido")).tooltip("show").addClass("select-required");
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            scrollToEl($("#telefono_input"));
            return false;
        } else {
            if ($("#telefono_input").intlTelInput("isValidNumber")) {
                //ok
            } else {
                if ($("#telefono_input").val().substring(0, 4) == "+337" && ($("#telefono_input").val().length == 12)) {
                    //ok
                } else {
                    $("#telefono_input").data("title", x_translate("Ingrese  un número de celular válido")).tooltip("show").addClass("select-required");
                    if (!$('#collapseOne').is(":visible")) {
                        $('#collapseOne').collapse('show');
                    }
                    scrollToEl($("#telefono_input"));
                    return false;
                }
            }
        }



        return true;

    };

    var validar_campos_requeridos_step2 = function () {
        //limpiar viejos tooltips
        $.each($("#frmRegistro input"), function (index, element) {
            var $element = $(element);
            $element.tooltip("destroy").removeClass("select-required");
        });

        $.each($("#frmRegistro select"), function (index, element) {
            var $element = $(element);
            $element.tooltip("destroy").removeClass("select-required");
        });
        $("#frmRegistro .select-required").removeClass("select-required");

        if ($("#pais_idpais option:selected").val() == "") {
            $("#pais_idpais").data("title", x_translate("Seleccione su país de residencia y país de trabajo para acceder a los beneficios de reintegro")).tooltip("show").addClass("select-required");
            if (!$('#collapseTwo').is(":visible")) {
                $('#collapseTwo').collapse('show');
            }
            scrollToEl($("#pais_idpais"));

            return false;
        }
        if ($("#pais_idpais_trabajo option:selected").val() == "") {
            $("#pais_idpais_trabajo").data("title", x_translate("Seleccione su país de residencia y país de trabajo para acceder a los beneficios de reintegro")).tooltip("show").addClass("select-required");
            if (!$('#collapseTwo').is(":visible")) {
                $('#collapseTwo').collapse('show');
            }
            scrollToEl($("#pais_idpais_trabajo"));
            return false;
        }


        if ($("#con_beneficios_reintegro").is(":checked")) {
            /**
             *  1-Francia
             *  2-Luxemburgo
             *  3-Bélgica
             *  4-Otro país
             **/
            var pais = $("#pais_idpais option:selected").val();

            //Francia
            if (pais == 1) {
                if ($("#tarjeta_vitale_input").val() == "") {
                    $("#tarjeta_vitale_input").data("title", x_translate("Ingrese su número de tarjeta Vitale")).tooltip("show").addClass("select-required");
                    if (!$('#collapseTwo').is(":visible")) {
                        $('#collapseTwo').collapse('show');
                    }
                    scrollToEl($("#tarjeta_vitale_input"));
                    return false;
                }

                if ($("#pais_idpais_trabajo").val() == 2 && $("#tarjeta_cns_input").val() == "") {
                    $("#tarjeta_cns_input").data("title", x_translate("Ingrese su número de tarjeta CNS")).tooltip("show").addClass("select-required");
                    if (!$('#collapseTwo').is(":visible")) {
                        $('#collapseTwo').collapse('show');
                    }
                    scrollToEl($("#tarjeta_cns_input"));
                    return false;
                }

                //verifcar preguntas cobertura facturacion
                if (!validar_preguntas_cobertura_facturacion()) {
                    return false;
                }

            } else if (pais == 2) {
                //Luxemburgo
                if ($("#tarjeta_cns_input").val() == "") {
                    $("#tarjeta_cns_input").data("title", x_translate("Ingrese su número de tarjeta CNS")).tooltip("show").addClass("select-required");
                    if (!$('#collapseTwo').is(":visible")) {
                        $('#collapseTwo').collapse('show');
                    }
                    scrollToEl($("#tarjeta_cns_input"));
                    return false;
                }
            } else if (pais == 3) {
                //Belgica
                if ($("#tarjeta_eID_input").val() == "") {
                    $("#tarjeta_eID_input").data("title", x_translate("Ingrese su número de tarjeta e-ID")).tooltip("show").addClass("select-required");
                    if (!$('#collapseTwo').is(":visible")) {
                        $('#collapseTwo').collapse('show');
                    }
                    scrollToEl($("#tarjeta_eID_input"));
                    return false;
                }

                if ($("#pais_idpais_trabajo").val() == 2 && $("#tarjeta_cns_input").val() == "") {
                    $("#tarjeta_cns_input").data("title", x_translate("Ingrese su número de tarjeta CNS")).tooltip("show").addClass("select-required");
                    if (!$('#collapseTwo').is(":visible")) {
                        $('#collapseTwo').collapse('show');
                    }
                    scrollToEl($("#tarjeta_cns_input"));
                    return false;
                }



            } else if (pais == 4) {
                //Otro Pais
                if ($("#tarjeta_pasaporte_input").val() == "") {
                    $("#tarjeta_pasaporte_input").data("title", x_translate("Ingrese su número de tarjeta Pasaporte")).tooltip("show").addClass("select-required");
                    if (!$('#collapseTwo').is(":visible")) {
                        $('#collapseTwo').collapse('show');
                    }
                    scrollToEl($("#tarjeta_pasaporte_input"));
                    return false;
                }
            }

        }
        return true;
    };

    var validar_preguntas_cobertura_facturacion = function () {
        $.each($("#div_cobertura_facturacion .pul-col-x2"), function (index, element) {
            var $element = $(element);
            $element.tooltip("destroy").removeClass("select-required");
        });

        if (!$("#beneficia_ald_si").is(":checked") && !$("#beneficia_ald_no").is(":checked")) {
            $("#div_beneficia_ald .pul-col-x2.check-holder").data("title", x_translate("Complete los campos obligatorios")).tooltip("show").addClass("select-required");
            if (!$('#collapseTwo').is(":visible")) {
                $('#collapseTwo').collapse('show');
            }
            scrollToEl($("#div_beneficia_ald"));
            return false;
        }
        if ($("#beneficia_ald_si").is(":checked") && $("#afeccion_idafeccion").val() == "") {
            $("#div_afeccion .select").data("title", x_translate("Complete los campos obligatorios")).tooltip("show").addClass("select-required");
            if (!$('#collapseTwo').is(":visible")) {
                $('#collapseTwo').collapse('show');
            }
            scrollToEl($("#div_afeccion"));
            return false;
        }
        if (!$("#beneficia_exempcion_si").is(":checked") && !$("#beneficia_exempcion_no").is(":checked")) {
            $("#div_beneficia_exempcion .pul-col-x2.check-holder").data("title", x_translate("Complete los campos obligatorios")).tooltip("show").addClass("select-required");
            if (!$('#collapseTwo').is(":visible")) {
                $('#collapseTwo').collapse('show');
            }
            scrollToEl($("#div_beneficia_exempcion"));
            return false;
        }
        if (!$("#posee_cobertura_si").is(":checked") && !$("#posee_cobertura_no").is(":checked")) {
            $("#div_posee_cobertura .pul-col-x2.check-holder").data("title", x_translate("Complete los campos obligatorios")).tooltip("show").addClass("select-required");
            if (!$('#collapseTwo').is(":visible")) {
                $('#collapseTwo').collapse('show');
            }
            scrollToEl($("#div_posee_cobertura"));
            return false;
        }
        if ($("#posee_cobertura_si").is(":checked") && $("#idobraSocial").val() == "") {
            $("#as_obra_social").data("title", x_translate("Complete los campos obligatorios")).tooltip("show").addClass("select-required");
            if (!$('#collapseTwo').is(":visible")) {
                $('#collapseTwo').collapse('show');
            }
            scrollToEl($("#div_obra_social"));
            return false;
        }
        if (!$("#medico_cabeza_si").is(":checked") && !$("#medico_cabeza_no").is(":checked")) {
            $("#div_medico_cabeza .pul-col-x2.check-holder").data("title", x_translate("Complete los campos obligatorios")).tooltip("show").addClass("select-required");
            if (!$('#collapseTwo').is(":visible")) {
                $('#collapseTwo').collapse('show');
            }
            scrollToEl($("#div_medico_cabeza"));
            return false;
        }
        if ($("#medico_cabeza_si").is(":checked") && !$("#medico_cabeza_externo").is(":checked") && $("#idmedico_cabecera").length === 0) {
            $("#div_buscador_medico_cabecera").show();
            $("#nombre_medico_cabecera").data("title", x_translate("Si has declarado un médico tratante debe seleccionarlo")).tooltip("show").addClass("select-required");
            if (!$('#collapseTwo').is(":visible")) {
                $('#collapseTwo').collapse('show');
            }
            scrollToEl($("#nombre_medico_cabecera"));
            return false;
        }
        return true;
    };
    var validar_campos_requeridos_familiar = function () {

        //limpiar viejos tooltips
        $.each($("#frmRegistro input"), function (index, element) {
            var $element = $(element);
            $element.tooltip("destroy").removeClass("select-required");
        });

        $.each($("#frmRegistro select"), function (index, element) {
            var $element = $(element);
            $element.tooltip("destroy").removeClass("select-required");
        });

        //validaciones 

        if ($("#nombre_input").val() == "") {
            $("#nombre_input").tooltip("show").addClass("select-required");
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            scrollToEl($("#nombre_input"));

            return false;
        }


        if ($("#apellido_input").val() == "") {
            $("#apellido_input").tooltip("show").addClass("select-required");
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            scrollToEl($("#apellido_input"));

            return false;
        }


        if ($("#fecha_nacimiento").val().length != 10 || (typeof (validatedate) == "function" && !validatedate($("#fecha_nacimiento").val()))) {
            $("#fecha_nacimiento").tooltip("show").addClass("select-required");
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            scrollToEl($("#fecha_nacimiento"));

            return false;
        }

        //validar fecha futura
        var time_actual = new Date().getTime();
        var arr_split = $("#fecha_nacimiento").val().split("/");
        var fecha_nac = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
        if (fecha_nac > time_actual) {
            $("#fecha_nacimiento").data("title", x_translate("La fecha de nacimiento no puede ser futura")).tooltip("show").addClass("select-required");
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            scrollToEl($("#fecha_nacimiento"));
            return false;
        }
        //validar mayor de edad
        var fecha_actual = new Date();
        var time_mayor_edad = fecha_actual.setFullYear(fecha_nac.getFullYear() + 18);

        if (time_actual > time_mayor_edad) {
            $("#fecha_nacimiento").data("title", x_translate("El paciente familiar no debe ser mayor de 18 años")).tooltip("show").addClass("select-required");
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            scrollToEl($("#fecha_nacimiento"));
            return false;
        }


        //validar relacion con el paciente
        if ($("#relacionGrupo_idrelacionGrupo").val() == "") {
            $("#relacionGrupo_idrelacionGrupo").tooltip("show").addClass("select-required");
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            scrollToEl($("#relacionGrupo_idrelacionGrupo"));

            return false;
        }

        return true;

    };

    function alert_resultado(data) {



        if (data.hasOwnProperty("is_cambio_celular") && data.is_cambio_celular == 1) {
            $("#cambio_nroCelular").text($("#telefono_input").val());
            $("#mul-validar-cel").show();
        }

        //si es paciente titular y completa los datos minimos requeridos redirigir a home paciente
        if ($("#usuarioweb_idusuarioweb").length == 1 && data.result && data.showModal) {

            x_alert(x_translate("Has terminado de completar la información de tu cuenta!"), function () {
                recargar(BASE_PATH + "panel-paciente/");
            });

        } else {
            $.alert({

                title: '',
                scrollToPreviousElement: false,
                scrollToPreviousElementAnimate: false,
                content: x_translate(data.msg),
                theme: 'material',
                backgroundDismiss: true,
                buttons: {

                }
            });
            //scrollToEl($("body"));
        }


    }
    //accion de validar y enviar el formulario con los datos del paciente
    $(".btnGuardarDatos").click(function () {

        //validamos los datos completos para el Titular
        if ($("#usuarioweb_idusuarioweb").length == 1) {
            if (!validar_campos_requeridos_step1() || !validar_campos_requeridos_step2()) {
                return false;
            }

            //enviamos el form
            x_sendForm($('#frmRegistro'), true, alert_resultado);

        } else {
            if (validar_campos_requeridos_familiar()) {
                x_sendForm($('#frmRegistro'), true, alert_resultado);
            }
        }

    });

    //metodo que muestra los campos necesarios de tarjetas de identificacion del paciente segun el pais seleccionado
    function cargar_tarjetas_identificacion() {

//verificamos si es familiar o titular para obtener el pais
        if ($("#usuarioweb_idusuarioweb").length == 0) {
            var titular = false;
            var pais = $("#pais_idpais").val();
            var pais_trabajo = $("#pais_idpais_trabajo ").val();
        } else {
            var titular = true;
            var pais = $("#pais_idpais option:selected").val();
            var pais_trabajo = $("#pais_idpais_trabajo option:selected").val();
        }
        //ocultamos todo inicialmente
        $("#div_tarjeta_vitale").hide();
        $("#div_tarjeta_eID").hide();
        $("#div_tarjeta_cns").hide();
        $("#div_tarjeta_pasaporte").hide();
        $("#div_cobertura_facturacion").hide();
        $('#buscador_medico_cabecera_container').hide();

        if (pais == "" || pais_trabajo == "") {
            $('#con_beneficios_reintegro').prop("checked", false);
            return;
        }


        /**
         *  1-Francia
         *  2-Luxemburgo
         *  3-Bélgica
         *  4-Otro país
         **/

        //pais residencia
        if (titular) {

            if (pais == 1) {
                $("#div_tarjeta_vitale").show();
                $("#div_cobertura_facturacion").show();
                $('#con_beneficios_reintegro').radiocheck('check');
                $('#buscador_medico_cabecera_container').show();

            } else if (pais == 2) {
                $("#div_tarjeta_cns").show();
                $('#buscador_medico_cabecera_container').hide();
                $('#con_beneficios_reintegro').radiocheck('check');
            } else if (pais == 3) {
                $("#div_tarjeta_eID").show();
                $('#buscador_medico_cabecera_container').hide();
            } else if (pais == 4) {
                $("#div_tarjeta_pasaporte").show();
                $('#buscador_medico_cabecera_container').hide();
            }

            //pais trabajo
            if (pais_trabajo == 2) {
                $("#div_tarjeta_cns").show();
                $('#con_beneficios_reintegro').radiocheck('check');
            }
        } else {
            //miembro de LUX se muestra su propia tarjeta CNS
            if (pais == 2 || pais_trabajo == 2) {
                $("#div_tarjeta_cns").show();
            }
        }
        $("#div_identificacion").show();

    }

    cargar_tarjetas_identificacion();

    //seleccion pais de residencia - muestra oculta tarjeta identificacion
    $("#pais_idpais").change(function () {
        $("#pais_idpais_trabajo").val("");
        $("#pais_idpais_trabajo").trigger("change");
        cargar_tarjetas_identificacion();

    });

    //seleccion pais de trabajo - muestra oculta tarjeta identificacion
    $("#pais_idpais_trabajo").change(function () {

        cargar_tarjetas_identificacion();

    });

    $('#con_beneficios_reintegro').on('change.radiocheck', function () {
        var pais = $("#pais_idpais option:selected").val();
        var pais_trabajo = $("#pais_idpais_trabajo option:selected").val();
        if (pais == "" || pais_trabajo == "") {
            $('#con_beneficios_reintegro').prop("checked", false);
            x_alert(x_translate("Seleccione su país de residencia y país de trabajo para acceder a los beneficios de reintegro"));
            $("#pais_idpais").parent().find(".select2-choice").addClass("select-required");
            $("#pais_idpais_trabajo").parent().find(".select2-choice").addClass("select-required");
            return false;
        }
        if ($("#con_beneficios_reintegro").is(":checked")) {
            // Do something
            // $("#div_paises").show();
            $("#div_identificacion").show();

        } else {
            // Do something
            //$("#div_paises").hide();
            $("#div_identificacion").hide();
        }

    });

    //mascaras de numeros tarjetas identificacion
    /*$("#tarjeta_vitale_input").on('keydown', function (event) {
     
     this.value = this.value.slice(0, this.maxLength);
     
     });*/
    $("#tarjeta_vitale_input").mask('000000000000000');
    $("#tarjeta_eID_input").mask('000000000000');
    $("#tarjeta_cns_input").mask('0000000000000');

    //alerta al querer redimensionar imagen de perfil - cropper no disponible
    $("#a_img_cropper").click(function () {
        x_alert(x_translate("ATENCIÓN: La imagen que usted ha subido se encuentra cargada en forma temporal. Las funciones de edición están deshabilitadas. Tras la creación del miembro de grupo familiar, usted podrá modificar, recortar y rotar la misma haciendo click sobre la imagen."));
    });

    //opciones date picker de fecha de nacimientos

    $('#fecha_nacimiento').mask("00/00/0000", {placeholder: "jj/mm/aaaa"});

    //accion completar campos y desplegar
    $('.panel-heading a').on('click', function (e) {
        $('.panel-heading a').not($(this)).find(".more-less").removeClass('fa-chevron-up').addClass('fa-chevron-down');
        $(this).find(".more-less").toggleClass('fa-chevron-down fa-chevron-up');

    });


    $('#collapseTwo').on('show.bs.collapse', function () {
        cargar_tarjetas_identificacion();
    });

    //Privacidad del paciente

    $('#permisos-nadie, #permisos-frecuentes, #permisos-todos').on('click', function (e) {

        if ($('#permisos-nadie').is(':checked')) {
            if ($('#permisos-nadie-disclaimer').not(':visible')) {
                $('#permisos-nadie-disclaimer').slideDown();
            }
            if ($('#permisos-frecuentes-disclaimer').is(':visible')) {
                $('#permisos-frecuentes-disclaimer').slideUp();
            }
        }

        if ($('#permisos-frecuentes').is(':checked')) {
            if ($('#permisos-frecuentes-disclaimer').not(':visible')) {
                $('#permisos-frecuentes-disclaimer').slideDown();
            }
            if ($('#permisos-nadie-disclaimer').is(':visible')) {
                $('#permisos-nadie-disclaimer').slideUp();
            }
        }

        if ($('#permisos-todos').is(':checked')) {
            if ($('#permisos-frecuentes-disclaimer').is(':visible')) {
                $('#permisos-frecuentes-disclaimer').slideUp();
            }
            if ($('#permisos-nadie-disclaimer').is(':visible')) {
                $('#permisos-nadie-disclaimer').slideUp();
            }
        }

    });
    //cobertura medica
    $('#as_obra_social').autocomplete({
        zIndex: 10000,
        serviceUrl: BASE_PATH + 'obrasocial_autosuggest.do',
        onSelect: function (data) {
            $("#idobraSocial").val(data.data).change();
        }
    });


    //validar el codigo de celular enviado por SMS
    $(".validarCodigoCelular").click(function () {
        var codigo = $(".codigo-cell").val();
        if (codigo == "") {
            x_alert(x_translate("En unos momentos recibiras un SMS con el código de validación de tu celular."));

        } else {
            $("#desplegable-validacion").spin("large");
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'validar_codigo_celular.do',
                    "codigoValidacionCelular=" + codigo,
                    function (data) {
                        $("#desplegable-validacion").spin(false);
                        x_alert(data.msg, recargar);

                    }
            );
        }
    });

    if ($("#completer").val() == "1") {
        if (!$('#collapseTwo').is(":visible")) {
            $('#collapseTwo').collapse('show');
        }
        setTimeout(function () {

            var pais = $("#pais_idpais option:selected").val();
            var pais_trabajo = $("#pais_idpais_trabajo option:selected").val();
            if (pais == "" || pais_trabajo == "") {
                $("#pais_idpais_trabajo").parent().find(".select2-choice").addClass("select-required");
                $("#pais_idpais").parent().find(".select2-choice").addClass("select-required");
                scrollToEl($("#pais_idpais"));
            }
        }, 1000);

        if ($("#medico_cabeza_si").is(":checked") && $("#idmedico_cabecera").length === 0) {
            $("#div_buscador_medico_cabecera").show();
            $("#nombre_medico_cabecera").data("title", x_translate("Si has declarado un médico tratante debe seleccionarlo")).tooltip("show").addClass("select-required");

            scrollToEl($("#nombre_medico_cabecera"));

        }



    }
});



