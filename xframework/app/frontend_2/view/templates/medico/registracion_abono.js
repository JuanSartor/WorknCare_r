$(document).ready(function() {
//     renderUI2("Main");
//    $(':radio, :checkbox').radiocheck();
    $('.switch-checkbox').bootstrapSwitch();

    /**
     * LOGIN
     */
    $('#timeout-trigger').on('click', function(e) {
        $('#mapc-login').hide();
        $('#mapc-passrecovery').hide();
        $('#mapc-recoverytext').hide();
    });

    $('#loginbtn').on('click', function(e) {
        $('#mapc-login').show();
        $('#mapc-passrecovery').hide();
        $('#mapc-recoverytext').hide();
    });

    $('.ForgotPassTrigger').on('click', function(e) {
        e.preventDefault();
        $('#mapc-login').hide();
        $('#mapc-passrecovery').fadeIn();
    });

    $('#mapc-sendpass').on('click', function(e) {
        e.preventDefault();
        $('#mapc-passrecovery').hide();
        $('#mapc-recoverytext').fadeIn();
    });

    $('.mapc-codigo-promocion').on('click', function(e) {
        e.preventDefault();
        $('.mapc-codigo-promocion-box').slideToggle();
    });

    /**
     * ACCORDION
     */
    $('#mapc-mi-cuenta-btn').on('click', function(e) {
        e.preventDefault();
        $('.mapc-mi-cuenta').slideUp();
        $('.mapc-mi-identificacion').slideDown();

        $('#signup-steps').children('li.active').removeClass('active');

        $('#signup-steps').children('li').eq(1).addClass('active');

    });

    $('#mapc-mi-identificacion-btn').on('click', function(e) {
        $('.mapc-mi-identificacion').slideUp();
        $('.mapc-pago').slideDown();

        $('#signup-steps').children('li.active').removeClass('active');

        $('#signup-steps').children('li').eq(2).addClass('active');

    });

    $('#mapc-finalizar-pago').on('click', function(e) {
        e.preventDefault();
        $('.mapc-transaccion-ok').slideDown();
        $('.mapc-transaccion-error').slideDown();
    });

    $('#accordion-trg-1').on('click', function(e) {
        e.preventDefault();
        if (validar_campos_requeridos_step1()) {
            $('#collapseOne').collapse('toggle');
            $('#collapseTwo').collapse('toggle');
        }
    });

$("#apellido_input").blur(function(){
        if ($("#apellido_input").val().length > 20) {
            $("#apellido_input").data("title", "Si su apellido es demasiado largo, utilice solo su apellido principal o iniciales").tooltip("show");
            $('html, body').animate({
                scrollTop: $("#apellido_input").offset().top - 200}, 1000);
              $("#apellido_input").val($("#apellido_input").val().substring(0,20));
            return false;
        }
    });
     $("#nombre_input").blur(function(){
        if ($("#nombre_input").val().length > 15) {
            $("#nombre_input").data("title", "Si su nombre es demasiado largo, utilice solo su nombre principal o iniciales").tooltip("show");
            $('html, body').animate({
                scrollTop: $("#nombre_input").offset().top - 200}, 1000);
              $("#nombre_input").val($("#nombre_input").val().substring(0,15));
            return false;
        }
    });
    var validar_campos_requeridos_step1 = function() {



        if ($("#nombre_input").val() == "") {
            $("#nombre_input")
                    .data("title", "Ingrese su nombre")
                    .tooltip("show");
            $('html, body').animate({
                scrollTop: $("#nombre_input").offset().top - 200
            }, 1000);

            return false;
        }
         if ($("#nombre_input").val().length > 15) {
        $("#nombre_input").data("title", "Su nombre es demasiado largo. Utilice solo su nombre principal o iniciales").tooltip("show");
        $('html, body').animate({
            scrollTop: $("#nombre_input").offset().top - 200}, 1000);
        return false;
    }

        if ($("#apellido_input").val() == "") {
            $("#apellido_input")
                    .data("title", "Ingrese su apellido")
                    .tooltip("show");
            $('html, body').animate({
                scrollTop: $("#apellido_input").offset().top - 200
            }, 1000);

            return false;
        }
        if ($("#nombre_input").val().length > 20) {
        $("#nombre_input").data("title", "Su apellido es demasiado largo. Utilice solo su apellido principal o iniciales").tooltip("show");
        $('html, body').animate({
            scrollTop: $("#apellido").offset().top - 200}, 1000);
        return false;
    }
        
       if($("#cont-imagen").attr("src")==undefined){
           $(".mapc-upload-box")
                    .data("title", "Adjunte foto de su DNI")
                    .tooltip("show");
            $('html, body').animate({
                scrollTop: $(".mapc-upload-box").offset().top - 200
            }, 1000);
             return false;
       }

        if ($("#email_input").val() == "") {
            $("#email_input")
                    .data("title", "Ingrese su email")
                    .tooltip("show");
            $('html, body').animate({
                scrollTop: $("#email_input").offset().top - 200
            }, 1000);


            return false;
        }

        if ($("#reemail_input").val() == "") {
            $("#reemail_input")
                    .data("title", "Ingrese nuevamente el email")
                    .tooltip("show");
            $('html, body').animate({
                scrollTop: $("#reemail_input").offset().top - 200
            }, 1000);


            return false;
        }

        if ($("#reemail_input").val() != $("#email_input").val()) {
            $("#reemail_input")
                    .data("title", "Las direcciones de email no coinciden")
                    .tooltip("show");
            $('html, body').animate({
                scrollTop: $("#reemail_input").offset().top - 200
            }, 1000);

            return false;
        }


        //Si el validador retorna que es muy débil la contraseña.
        if ($("[data-meter='password_aut']").hasClass("veryweak")) {
            //La contraseña es muy débil, debe tener al menos 8 caracteres
            $("#password_aut")
                    .data("title", "La contraseña es muy débil, debe tener al menos 8 caracteres")
                    .tooltip("show");
            return false;
        }
        if ($('#password_aut').val() == "") {
            $("#password_aut")
                    .data("title", "Ingrese Contraseña")
                    .tooltip("show");
            return false;
        }

        var password1 = $.trim($('#password_aut').val());
        var password2 = $.trim($('#repassword_aut').val());

        if (password1 === password2) {
            var valor = Base64.encode(SHA1(password1));
            $("#password").val(valor);

        }
        else {
            $("#password_aut")
                    .data("title", "Las contraseñas no coinciden")
                    .tooltip("show");
            $('html, body').animate({
                scrollTop: $("#password_aut").offset().top - 200
            }, 1000);

            return false;
        }

        return true;
    };

    var validar_campos_requeridos_step2 = function() {
        if ($("#especialidad_medico").val() == "") {
            $("#especialidad_medico")
                    .data("title", $("#especialidad_medico").data("title"))
                    .tooltip("show");
            $('html, body').animate({
                scrollTop: $("#especialidad_medico").offset().top - 200
            }, 1000);

            return false;
        }

        if ($("#subespecialidad_medico").val() == "") {
            $("#subespecialidad_medico")
                    .data("title", $("#subespecialidad_medico").data("title"))
                    .tooltip("show");
            $('html, body').animate({
                scrollTop: $("#subespecialidad_medico").offset().top - 200
            }, 1000);

            return false;
        }

        if ($("#matriculaNacional_input").val() == "" && $("#matriculaProvincial_input").val() == "") {

            $("#matriculaNacional_input").data("title", $("#matriculaNacional_input").attr("data-msg-required"))
                    .tooltip("show");

            $("#matriculaProvincial_input").data("title", $("#matriculaProvincial_input").attr("data-msg-required"))
                    .tooltip("show");

            $("#matriculaNacional_input").on("focusout", function() {
                if ($("#matriculaNacional_input").val() != "") {
                    $("#matriculaProvincial_input").tooltip("destroy");
                }



            });

            $("#matriculaProvincial_input").on("focusout", function() {
                if ($("#matriculaProvincial_input").val() != "") {
                    $("#matriculaNacional_input").tooltip("destroy");
                }

            });
            $('html, body').animate({
                scrollTop: $("#matriculaNacional_input").offset().top - 200
            }, 1000);


            return false;
        }


        if ($("#colegioInscripto_input").val() == "" && $("#colegioInscriptoProvincial_input").val() == "") {


            if ($("#matriculaNacional_input").val() != "") {
                $("#colegioInscripto_input").data("title", $("#colegioInscripto_input").attr("data-msg-required"))
                        .tooltip("show");
            }

            if ($("#matriculaProvincial_input").val() != "") {
                $("#colegioInscriptoProvincial_input").data("title", $("#colegioInscriptoProvincial_input").attr("data-msg-required"))
                        .tooltip("show");
            }
            $('html, body').animate({
                scrollTop: $("#matriculaNacional_input").offset().top - 200
            }, 1000);

            return false;
        }

        if ($("#provincia_idprovincia").val() == "") {
            $("#provincia_idprovincia")
                    .data("title", $("#provincia_idprovincia").data("title"))
                    .tooltip("show");
            $('html, body').animate({
                scrollTop: $("#provincia_idprovincia").offset().top - 200
            }, 1000);

            return false;
        }
        var cuit = $("#cuit_input").val();
        if (!cuit.match(/^[0-9]{2}-[0-9]{8}-[0-9]$/) || (cuit.substr(0, 2) != "20" && cuit.substr(0, 2) != "23" && cuit.substr(0, 2) != "27")) {
            $("#cuit_input").data("title", $("#cuit_input").attr("data-msg-required"))
                    .tooltip("show");

            $('html, body').animate({
                scrollTop: $("#cuit_input").offset().top - 200
            }, 1000);

            return false;
        }


        return true;
    };

    $('#accordion-trg-2').on('click', function(e) {
        e.preventDefault();

        if (!validar_campos_requeridos_step1() || !validar_campos_requeridos_step2()) {
            return false;
        }

        if (!$("#terminos_condiciones").is(":checked")) {
            x_alert("Debe aceptar los términos y condiciones");
            return;
        }
        if (grecaptcha.getResponse() == "") {
            x_alert("Debe marcar la casilla de verificación");
            return false;
        }



        $("#div_registracion_medico").spin("large");
        x_sendForm($('#frmRegistro'), true, function(data) {
            $("#div_registracion_medico").spin(false);

            if (data.result) {

                window.location.href = BASE_PATH + "profesional/abono-proceso-compra-" + data.id + ".html";
            } else {
                grecaptcha.reset();
                
                //limpiar plugin fortaleza password
                $("[data-meter='password_aut']").html("");
            $("[data-meter='repassword_aut']").html("");

            $("[data-meter='password_aut']").removeClass("veryweak");
            $("[data-meter='password_aut']").removeClass("medium");
            $("[data-meter='password_aut']").removeClass("strong");
            $("[data-meter='repassword_aut']").removeClass("veryweak");
            $("[data-meter='repassword_aut']").removeClass("medium");
            $("[data-meter='repassword_aut']").removeClass("strong");
                x_alert(data.msg);
            }
        });

    });

    $("#collapsed_datos_profesionales").on('click', function(e) {
        e.preventDefault();
        if (validar_campos_requeridos_step1()) {
            if ($("#collapseOne").hasClass("in")) {
                $('#collapseOne').collapse('toggle');
            }

            $('#collapseTwo').collapse('toggle');
        }
    });

    /**
     * Reset pass
     */
    $("#frm_reset_pass_abono").validate({
        showErrors: function(errorMap, errorList) {

            // Clean up any tooltips for valid elements
            $.each(this.validElements(), function(index, element) {
                var $element = $(element);

                $element.data("title", "") // Clear the title - there is no error associated anymore
                        .removeClass("error")
                        .tooltip("destroy");
            });

            // Create new tooltips for invalid elements
            $.each(errorList, function(index, error) {
                var $element = $(error.element);

                $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                        .data("title", error.message)
                        .addClass("error")
                        .tooltip(); // Create a new tooltip based on the error messsage we just set in the title
            });
        },
        submitHandler: function(form) {
            x_sendForm($('#frm_reset_pass_abono'), true, alert_resultado_reset);
            return false;
        }
    });

    function alert_resultado_reset(data) {
        if (data.result) {
            x_alert("Se ha enviado un email para que recupere su contraseña");
        }
        else {
            x_alert(data.msg);
        }
    }


    /*
     * 
     * LOGIN
     */

    $("#frm_login_form_abono").validate({
        showErrors: function(errorMap, errorList) {

            // Clean up any tooltips for valid elements
            $.each(this.validElements(), function(index, element) {
                var $element = $(element);

                $element.data("title", "") // Clear the title - there is no error associated anymore
                        .removeClass("error")
                        .tooltip("destroy");
            });

            // Create new tooltips for invalid elements
            $.each(errorList, function(index, error) {
                var $element = $(error.element);

                $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                        .data("title", error.message)
                        .addClass("error")
                        .tooltip(); // Create a new tooltip based on the error messsage we just set in the title
            });
        },
        submitHandler: function(form) {
            var password = $.trim($('#password_form_abono_input').val());

            var valor = Base64.encode(SHA1(password));
            $("#password_form_abono").val(valor);

            x_sendForm($('#frm_login_form_abono'), true, alert_resultado);

            return false;
        }
    });

    function alert_resultado(data) {
        if (data.result) {
            //Paso al siguiente TAB
            if (data.usuario == "medico") {
                window.location.href = BASE_PATH + "panel-medico/abono-proceso-compra/";
            } else if (data.usuario == "paciente") {
                x_alert("Debe iniciar sesión con su cuenta de médico");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH+'logout.do',
                        '',{});
            }
        } else {
            x_alert(data.msg);
        }
    }


    /**
     * Formulario alta
     */
    $("#especialidad_medico").change(function() {
        updateComboBox("#especialidad_medico", 'subespecialidad_medico', 'ManagerSubEspecialidades', 'getCombo', 0, "Seleccionar...");
        //$("#subespecialidad_medico").prop("selectedIndex", 0).change();
    });

    $("#cuit_input").inputmask("99-99999999-9");


    var scroll_top = function(selector) {
        $('html, body').animate({
            scrollTop: $("#email_input").offset().top - 100
        }, 1000);
    };




    if (parseInt($("#idmedico_abono").val()) > 0) {
        $('.mapc-mi-cuenta').slideUp();

        $('.mapc-pago').slideDown();

        $('#signup-steps').children('li.active').removeClass('active');

        $('#signup-steps').children('li').eq(2).addClass('active');

        x_loadModule('medico', 'proceso_pago', 'idmedico=' + $("#idmedico_abono").val(), 'section_registracion_abono', BASE_PATH + "frontend_2");
    }

    $('#password_aut,#repassword_aut').strength({
        strengthClass: 'input_password_strength',
        strengthMeterClass: 'strength_meter',
        strengthButtonClass: 'button_strength',
        strengthButtonText: 'Show Password',
        strengthButtonTextToggle: 'Hide Password'
    });

    $(".button_strength").hide();



});

