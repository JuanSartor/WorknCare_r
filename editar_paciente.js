$(document).ready(function () {




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
            $element.tooltip("destroy");
        });

        $.each($("#frmRegistro select"), function (index, element) {
            var $element = $(element);
            $element.tooltip("destroy");
        });

        //validaciones 

        //validar nombre
        if ($("#nombre_input").val() == "") {
            $("#nombre_input").tooltip("show");
            scrollToEl($("#nombre_input"));
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            return false;
        }

        //verificar apellido
        if ($("#apellido_input").val() == "") {
            $("#apellido_input").tooltip("show");
            scrollToEl($("#apellido_input"));
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            return false;
        }





        //verificar fecha de nacimiento
        if ($("#fecha_nacimiento").val() == "") {
            $("#fecha_nacimiento").data("title", x_translate("Ingrese su fecha de nacimiento")).tooltip("show");
            $('html, body').animate({
                scrollTop: $("#fecha_nacimiento").offset().top - 200}, 1000);
            return false;
        }



        //validar fecha futura
        var time_actual = new Date().getTime();
        var arr_split = $("#fecha_nacimiento").val().split("/");
        var fecha_nac = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
        if (fecha_nac > time_actual) {
            $("#fecha_nacimiento").data("title", x_translate("La fecha de nacimiento no puede ser futura")).tooltip("show");
            $('html, body').animate({
                scrollTop: $("#fecha_nacimiento").offset().top - 200}, 1000);
            return false;
        }
        //validamos datos de  pacientes familiares
        if ($("#usuarioweb_idusuarioweb").length == 0) {

            if ($("#pais_idpais option:selected").val() == "") {
                $("#pais_idpais").data("title", x_translate("Seleccione su país de residencia")).tooltip("show");
                $('html, body').animate({
                    scrollTop: $("#pais_idpais").offset().top - 200}, 1000);
                return false;
            }
            //validar mayor de edad
            var fecha_actual = new Date();
            var time_mayor_edad = fecha_actual.setFullYear(fecha_nac.getFullYear() + 16);

            if (time_actual > time_mayor_edad) {
                $("#fecha_nacimiento").data("title", x_translate("El paciente familiar no debe ser mayor 16 años")).tooltip("show");
                $('html, body').animate({
                    scrollTop: $("#fecha_nacimiento").offset().top - 200}, 1000);
                return false;
            }




            if ($("#relacionGrupo_idrelacionGrupo").val() == "") {
                $("#relacionGrupo_idrelacionGrupo").tooltip("show");
                scrollToEl($("#relacionGrupo_idrelacionGrupo"));
                if (!$('#collapseOne').is(":visible")) {
                    $('#collapseOne').collapse('show');
                }
                return false;
            }
        }



        //si hay telefono verifico la longitud


        if ($("#telefono_input").val() == "") {

            $("#telefono_input").data("title", x_translate("Ingrese  un número de celular válido")).tooltip("show");
            scrollToEl($("#telefono_input"));
            return false;
        } else {
            if ($("#telefono_input").intlTelInput("isValidNumber")) {
                //ok
            } else {
                if ($("#telefono_input").val().substring(0, 4) == "+337" && ($("#telefono_input").val().length == 12)) {
                    //ok
                } else {
                    $("#telefono_input").data("title", x_translate("Ingrese  un número de celular válido")).tooltip("show");
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
            $element.tooltip("destroy");
        });

        $.each($("#frmRegistro select"), function (index, element) {
            var $element = $(element);
            $element.tooltip("destroy");
        });


        if ($("#con_beneficios_reintegro").is(":checked")) {
            /**
             *  1-Francia
             *  2-Luxemburgo
             *  3-Bélgica
             *  4-Otro país
             **/
            var pais = $("#pais_idpais option:selected").val();

            if (pais != "") {
                $("#pais_idpais").parent().find(".select2-choice").removeClass("select-required");
            }

            //Francia
            if (pais == 1) {
                if ($("#tarjeta_vitale_input").val() == "") {
                    $("#tarjeta_vitale_input").data("title", x_translate("Ingrese su número de tarjeta Vitale")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#tarjeta_vitale_input").offset().top - 200}, 1000);
                    if (!$('#collapseTwo').is(":visible")) {
                        $('#collapseTwo').collapse('show');
                    }
                    return false;
                }



                if ($("#pais_idpais_trabajo").val() == 92 && $("#tarjeta_cns_input").val() == "") {
                    $("#tarjeta_cns_input").data("title", x_translate("Ingrese su número de tarjeta CNS")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#tarjeta_cns_input").offset().top - 200}, 1000);
                    if (!$('#collapseTwo').is(":visible")) {
                        $('#collapseTwo').collapse('show');
                    }
                    return false;
                }
                if ($("#pais_idpais_trabajo").val() == "") {
                    console.log("falta paise");
                    scrollToEl($("#pais_idpais_trabajo"));
                    $("#pais_idpais_trabajo").data("title", "Lieu de travail").tooltip("show");

                    $("#pais_idpais_trabajo").parent().find(".select2-choice").addClass("select-required");
                } else {
                    $("#pais_idpais_trabajo").parent().find(".select2-choice").removeClass("select-required");
                }

            } else if (pais == 2) {
                //Luxemburgo
                if ($("#tarjeta_cns_input").val() == "") {
                    $("#tarjeta_cns_input").data("title", x_translate("Ingrese su número de tarjeta CNS")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#tarjeta_cns_input").offset().top - 200}, 1000);
                    if (!$('#collapseTwo').is(":visible")) {
                        $('#collapseTwo').collapse('show');
                    }
                    return false;
                }
            } else if (pais == 3) {
                //Belgica
                if ($("#tarjeta_eID_input").val() == "") {
                    $("#tarjeta_eID_input").data("title", x_translate("Ingrese su número de tarjeta e-ID")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#tarjeta_eID_input").offset().top - 200}, 1000);
                    if (!$('#collapseTwo').is(":visible")) {
                        $('#collapseTwo').collapse('show');
                    }
                    return false;
                }



                if ($("#pais_idpais_trabajo").val() == 92 && $("#tarjeta_cns_input").val() == "") {
                    $("#tarjeta_cns_input").data("title", x_translate("Ingrese su número de tarjeta CNS")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#tarjeta_cns_input").offset().top - 200}, 1000);
                    if (!$('#collapseTwo').is(":visible")) {
                        $('#collapseTwo').collapse('show');
                    }
                    return false;
                }



            } else if (pais == 4) {
                //Otro Pais
                if ($("#tarjeta_pasaporte_input").val() == "") {
                    $("#tarjeta_pasaporte_input").data("title", x_translate("Ingrese su número de tarjeta Pasaporte")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#tarjeta_pasaporte_input").offset().top - 200}, 1000);
                    if (!$('#collapseTwo').is(":visible")) {
                        $('#collapseTwo').collapse('show');
                    }
                    return false;
                }
            } else {
                console.log("falta paise");
                scrollToEl($("#pais_idpais"));
                $("#pais_idpais").data("title", "Pays de résidence").tooltip("show");
                $("#pais_idpais").parent().find(".select2-choice").addClass("select-required");
            }

            if ($("#pais_idpais_trabajo").val() != "") {
                $("#pais_idpais_trabajo").parent().find(".select2-choice").removeClass("select-required");
            }


        }
        return true;
    }

    var validar_campos_requeridos_familiar = function () {

        //limpiar viejos tooltips
        $.each($("#frmRegistro input"), function (index, element) {
            var $element = $(element);
            $element.tooltip("destroy");
        });

        $.each($("#frmRegistro select"), function (index, element) {
            var $element = $(element);
            $element.tooltip("destroy");
        });

        //validaciones 

        if ($("#nombre_input").val() == "") {
            $("#nombre_input").tooltip("show");
            scrollToEl($("#nombre_input"));
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            return false;
        }


        if ($("#apellido_input").val() == "") {
            $("#apellido_input").tooltip("show");
            scrollToEl($("#apellido_input"));
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            return false;
        }


        if ($("#fecha_nacimiento").val() == "") {
            $("#fecha_nacimiento").tooltip("show");
            scrollToEl($("#fecha_nacimiento"));
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            return false;
        }

        //validar fecha futura
        var time_actual = new Date().getTime();
        var arr_split = $("#fecha_nacimiento").val().split("/");
        var fecha_nac = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
        if (fecha_nac > time_actual) {
            $("#fecha_nacimiento").data("title", x_translate("La fecha de nacimiento no puede ser futura")).tooltip("show");
            $('html, body').animate({
                scrollTop: $("#fecha_nacimiento").offset().top - 200}, 1000);
            return false;
        }
        //validar mayor de edad
        var fecha_actual = new Date();
        var time_mayor_edad = fecha_actual.setFullYear(fecha_nac.getFullYear() + 16);

        if (time_actual > time_mayor_edad) {
            $("#fecha_nacimiento").data("title", x_translate("El paciente familiar no debe ser mayor 16 años")).tooltip("show");
            $('html, body').animate({
                scrollTop: $("#fecha_nacimiento").offset().top - 200}, 1000);
            return false;
        }



        if ($("#relacionGrupo_idrelacionGrupo").val() == "") {
            $("#relacionGrupo_idrelacionGrupo").tooltip("show");
            scrollToEl($("#relacionGrupo_idrelacionGrupo"));
            if (!$('#collapseOne').is(":visible")) {
                $('#collapseOne').collapse('show');
            }
            return false;
        }

        return true;

    };

    $("#telefono_input").intlTelInput({
        nationalMode: false,
        preferredCountries: ['fr', 'be', 'lu'],
        utilsScript: BASE_PATH + "xframework/core/libs/libs_js/intl-tel-input/build/js/utils.js"
    });

    function alert_resultado(data) {



        if (data.hasOwnProperty("is_cambio_celular") && data.is_cambio_celular == 1) {
            $("#cambio_nroCelular").text($("#telefono_input").val());
            $("#mul-validar-cel").show();
        }
        
        //si es paciente titular y completa los datos minimos requeridos redirigir a home paciente
        if ($("#usuarioweb_idusuarioweb").length == 1 && data.result && data.showModal) {

            x_alert("Vous avez terminé de compléter l'information de votre compte!", function () {
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
            scrollToEl($("body"));
        }


    }
    //accion de validar y enviar el formulario para la creacion del miembro de grupo
    $(".btnCrearMiembro").click(function () {


        if ($("#usuarioweb_idusuarioweb").length == 1) {
            if (validar_campos_requeridos_step1() && validar_campos_requeridos_step2()) {

                x_sendForm($('#frmRegistro'), true, alert_resultado);
            }
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

        $("#div_tarjeta_vitale").hide();
        $("#div_tarjeta_eID").hide();
        $("#div_tarjeta_cns").hide();
        $("#div_tarjeta_pasaporte").hide();

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

            } else if (pais == 2) {
                $("#div_tarjeta_cns").show();
                $("#div_cobertura_facturacion").hide();
                $('#con_beneficios_reintegro').radiocheck('check');
            } else if (pais == 3) {
                $("#div_tarjeta_eID").show();
                $("#div_cobertura_facturacion").hide();
            } else if (pais == 4) {
                $("#div_tarjeta_pasaporte").show();
                $("#div_cobertura_facturacion").hide();
            }
       
        //pais trabajo
        if (pais_trabajo == 2) {
            $("#div_tarjeta_cns").show();
            $('#con_beneficios_reintegro').radiocheck('check');

        }
        }else{
            //miembro de LUX se muestra su propia tarjeta CNS
             if (pais == 2 || pais_trabajo == 2) {
                   $("#div_tarjeta_cns").show();
             }
        }

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
      $("#tarjeta_vitale_input").on('keydown',function(event){
       this.value=this.value.slice(0,this.maxLength-1);
    });
    $("#tarjeta_eID_input").on('keydown',function(event){
  
       this.value=this.value.slice(0,this.maxLength-1);
    });
    $("#tarjeta_cns_input").on('keydown',function(event){
       this.value=this.value.slice(0,this.maxLength-1);
    });

    //opciones de sexo del paciente
    $('#sexo-switch').bootstrapSwitch('onText', 'Homme');
    $('#sexo-switch').bootstrapSwitch('offText', 'Femme');



    //alerta al querer redimensionar imagen de perfil - cropper no disponible
    $("#a_img_cropper").click(function () {
        x_alert(x_translate("ATENCIÓN: La imagen que usted ha subido se encuentra cargada en forma temporal. Las funciones de edición están deshabilitadas. Tras la creación del miembro de grupo familiar, usted podrá modificar, recortar y rotar la misma haciendo click sobre la imagen."));
    });

    //opciones date picker de fecha de nacimientos

    $("#datetimepicker1")
            .datetimepicker({pickTime: false, language: 'fr'});

    $("#fecha_nacimiento").inputmask("d/m/y");


    $('#accordion-pul-trg').on('click', function (e) {
        e.preventDefault();

        validar_campos_requeridos_step1();


    });



    //accion completar campos y desplegar
    $('#accordion-trg-1').on('click', function (e) {
        e.preventDefault();
        e.stopPropagation();
        console.log("click1");


    });

    $('#accordion-trg-2').on('click', function (e) {
        e.preventDefault();
        e.stopPropagation();

        validar_campos_requeridos_step1();

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



    $("#posee_cobertura_si").on('change.radiocheck', function () {
        $("#div_obra_social").slideDown();

    })

    $("#posee_cobertura_no").on('change.radiocheck', function () {
        $("#div_obra_social").slideUp();

    })
    $("#beneficia_ald_si").on('change.radiocheck', function () {
        $("#div_afeccion").slideDown();

    })

    $("#beneficia_ald_no").on('change.radiocheck', function () {
        $("#div_afeccion").slideUp();

    })

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
        setTimeout(function () {

            var pais = $("#pais_idpais option:selected").val();
            var pais_trabajo = $("#pais_idpais_trabajo option:selected").val();
            if (pais == "" || pais_trabajo == "") {
                $("#pais_idpais_trabajo").parent().find(".select2-choice").addClass("select-required");
                $("#pais_idpais").parent().find(".select2-choice").addClass("select-required");
            }
        }, 3000);

    }





});



