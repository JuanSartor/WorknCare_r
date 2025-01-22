
var step1 = function () {
    scrollToEl($("body"));
    $("#span_steps").text("1/5");
};
var step2 = function () {
    scrollToEl($("body"));
    $("#span_steps").text("2/5");
};
var step3 = function () {
    scrollToEl($("body"));
    $("#span_steps").text("3/5");
};
var step4 = function () {



    scrollToEl($("body"));
    $("#span_steps").text("4/5");
};
var step5 = function () {
    $('#numero_adeli').keyup(function () {
        this.value = this.value.toUpperCase();
    });
    //Francia
    if ($("#pais_idpais").val() == 1) {
        //verificar si especialidad utiliza numero RPPS:0, ADELI:1, Otro:2
        if ($("#especialidad_idespecialidad option:selected").data("identificacion") == 1) {
            $("#div_rpps").hide();
            $("#div_adeli").show();
            $("#div_numero_identificacion").hide();
        } else if ($("#especialidad_idespecialidad option:selected").data("identificacion") == 2) {
            $("#div_rpps").hide();
            $("#div_adeli").hide();
            $("#div_numero_identificacion").show();
        } else {
            $("#div_rpps").show();
            $("#div_numero_identificacion").hide();
            $("#div_adeli").hide();
        }
        $("#div_cps").show();
    } else {
        //Luxemburg
        $("#div_rpps").hide();
        $("#div_numero_identificacion").hide();
        $("#div_adeli").hide();
        $("#div_cps").hide();
    }
    scrollToEl($("body"));
    $("#span_steps").text("5/6");
    $("#numero_rpps").mask('00000000000');
    //$("#numero_adeli").mask('000000000');

};
var step6 = function () {
    scrollToEl($("body"));
    $("#span_steps").text("6/6");
};
//agregamos el + al numero de telefono
$("#telefono_input").on("keyup", function () {
    if ($(this).val().substring(0, 1) != "+") {
        $(this).val("+" + $(this).val());
    }
});
var validarStep1 = function () {

    //validar email
    //expresion regular para mail
    $("#email_input").val($("#email_input").val().trim());
    $("#reemail_input").val($("#reemail_input").val().trim());
    if (!validarEmail($("#email_input").val())) {
        $("#email_input").data("title", x_translate("Ingrese un email válido")).tooltip("show");
        $('html, body').animate({
            scrollTop: $("#email_input").offset().top - 200}, 1000);
        return false;
    }
    if ($("#reemail_input").val() == "") {
        $("#reemail_input").data("title", x_translate("Reingrese su email")).tooltip("show");
        $('html, body').animate({
            scrollTop: $("#reemail_input").offset().top - 200}, 1000);
        return false;
    }
    //coincidencia de los 2 email
    if ($("#email_input").val() != $("#reemail_input").val()) {
        $("#reemail_input").data("title", x_translate("Las casillas de correo electrónico no coinciden")).tooltip("show");
        $('html, body').animate({
            scrollTop: $("#reemail_input").offset().top - 200}, 1000);
        return false;
    }

    //validar contraseñas

    //Si el validador retorna que es muy débil la contraseña.
    if (!$("[data-meter='password_aut']").hasClass("strong")) {
        $("#password_aut")
                .data("title", x_translate("La contraseña es muy débil, debe tener al menos 8 caracteres, una mayúscula y un número"))
                .tooltip("show");
        $('html, body').animate({
            scrollTop: $("#password_aut").offset().top - 100
        }, 1000);
        return false;
    }

    if ($("#password_aut").val() == "") {
        $("#password_aut").data("title", x_translate("Ingrese un contraseña")).tooltip("show");
        $('html, body').animate({
            scrollTop: $("#password_aut").offset().top - 200}, 1000);
        return false;
    }

    if ($("#repassword_aut").val() == "") {
        $("#repassword_aut").data("title", x_translate("Reingrese su contraseña")).tooltip("show");
        $('html, body').animate({
            scrollTop: $("#repassword_aut").offset().top - 200}, 1000);
        return false;
    }

    var password1 = $.trim($('#password_aut').val());
    var password2 = $.trim($('#repassword_aut').val());
    if (password1 !== password2) {
        $("#repassword_aut").data("title", x_translate("Las contraseñas no coinciden")).tooltip("show");
        $('html, body').animate({
            scrollTop: $("#repassword_aut").offset().top - 200}, 1000);
        return false;
    }

    //si hay telefono verifico la longitud

    if ($("#telefono_input").val() == "") {

        $("#telefono_input").data("title", x_translate("Ingrese  un número de celular válido")).tooltip("show");
        $('html, body').animate({
            scrollTop: $("#telefono_input").offset().top - 200}, 1000);
        return false;
    } else {
        if ($("#telefono_input").intlTelInput("isValidNumber")) {
            //ok
        } else {
            if ($("#telefono_input").val().substring(0, 4) == "+337" && ($("#telefono_input").val().length == 12)) {
                //ok
            } else {
                $("#telefono_input").data("title", x_translate("Ingrese  un número de celular válido")).tooltip("show");
                $('html, body').animate({
                    scrollTop: $("#telefono_input").offset().top - 200}, 1000);
                return false;
            }
        }
    }

    if (!$("#terminos_condiciones").is(":checked")) {
        x_alert(x_translate("Debe aceptar los términos y condiciones de uso del sistema"));
        return false;
    }

    //codificamos la contraseña

    var valor = Base64.encode(SHA1(password1));
    $("#password").val(valor);
    $('#password_aut, #repassword_aut').val("");
    return true;
};
var validarStep2 = function () {

    //verificar codigo
    if ($("#codigo_input").val() == "") {
        $("#codigo_input").data("title", x_translate("Ingrese el código de verificación para continuar")).tooltip("show");
        $('html, body').animate({
            scrollTop: $("#codigo_input").offset().top - 200}, 1000);
        return false;
    }
    return true;
}
var validarStep3 = function () {

//verificar nombre
    if ($("#nombre_input").val() == "") {
        $("#nombre_input").data("title", x_translate("Ingrese su nombre")).tooltip("show");
        $('html, body').animate({
            scrollTop: $("#nombre_input").offset().top - 200}, 1000);
        return false;
    }

//verificar apellido
    if ($("#apellido_input").val() == "") {
        $("#apellido_input").data("title", x_translate("Ingrese su apellido")).tooltip("show");
        $('html, body').animate({
            scrollTop: $("#apellido_input").offset().top - 200}, 1000);
        return false;
    }


    return true;
};
var validarStep4 = function () {

    //verificar codigo
    if ($("#pais_idpais").val() == "") {
        $("#pais_idpais").data("title", x_translate("Seleccione el país donde tiene establecido su consultorio físico")).tooltip("show");
        $('html, body').animate({
            scrollTop: $("#pais_idpais").offset().top - 200}, 1000);
        return false;
    }
    return true;
}
var validarStep5 = function () {
    $("#form_registro_medico_step5 .select-required").removeClass("select-required");
    if ($("#especialidad_idespecialidad").val() == "") {
        $("#especialidad_idespecialidad").data("title", x_translate("Seleccione una especialidad")).tooltip("show").addClass("select-required");
        $('html, body').animate({
            scrollTop: $("#especialidad_idespecialidad").offset().top - 200}, 1000);
        return false;
    }
//verificacion numero registro en Francia
    if ($("#pais_idpais").val() == 1) {
//verificar si la especialidad utiliza numero RPPS:0 o ADELI:1
        console.log($("#especialidad_idespecialidad option:selected").data("identificacion"));
        if ($("#especialidad_idespecialidad option:selected").data("identificacion") == 1) {
            if ($("#numero_adeli").val() == "") {
                $("#numero_adeli").data("title", x_translate("Ingrese su número Adeli")).tooltip("show").addClass("select-required");
                $('html, body').animate({
                    scrollTop: $("#numero_adeli").offset().top - 200}, 1000);
                return false;
            }
        } else if ($("#especialidad_idespecialidad option:selected").data("identificacion") == 2) {
            if ($("#numero_identificacion").val() == "") {
                $("#numero_identificacion").data("title", x_translate("Ingrese su número de identificación")).tooltip("show").addClass("select-required");
                $('html, body').animate({
                    scrollTop: $("#numero_identificacion").offset().top - 200}, 1000);
                return false;
            }
        } else {
            if ($("#numero_rpps").val() == "") {
                $("#numero_rpps").data("title", x_translate("Ingrese su número RPPS")).tooltip("show").addClass("select-required");
                $('html, body').animate({
                    scrollTop: $("#numero_rpps").offset().top - 200}, 1000);
                return false;
            }
        }
    }
    return true;
};
var validarStep6 = function () {
    return true;
};
$(document).ready(function () {


    $('#wizard_registro_medico').easyWizard({
        showButtons: false,
        submitButton: false,
        before: function (wizardObj, currentStepObj, nextStepObj) {

            var callback = nextStepObj.data("callback");
            if (typeof (callback) != "undefined") {
                eval(callback + "()");
            }

        },
        beforeSubmit: function (wizardObj) {
        }
    });
    //plugin numero celular
    $("#telefono_input").intlTelInput({
        nationalMode: false,
        preferredCountries: ['fr', 'be', 'lu'],
        utilsScript: BASE_PATH + "xframework/core/libs/libs_js/intl-tel-input/build/js/utils.js"
    });
    $("#telefono_input").mask("+0000000000000");
    $('#password_aut,#repassword_aut').strength({
        strengthClass: 'input_password_strength',
        strengthMeterClass: 'strength_meter',
        strengthButtonClass: 'button_strength',
        strengthButtonText: 'Show Password',
        strengthButtonTextToggle: 'Hide Password'
    });
    $(".button_strength").hide();
    $(".btn-siguiente").click(function (e) {

        e.preventDefault();
        var step = $(this).data("step");
        grecaptcha.ready(function () {
            grecaptcha.execute(RECAPTCHA_PUBLIC, {action: 'submit'}).then(function (token) {
                $(".g-recaptcha-response").val(token);
                //limpiamos los tooltip de validacion anteriores
                $.each($('#form_registro_medico_step' + step + ' input'), function (index, error) {
                    var $element = $(error);
                    $element.tooltip("destroy");
                });
                $.each($('#form_registro_medico_step' + step + ' div'), function (index, error) {
                    var $element = $(error);
                    $element.tooltip("destroy");
                });
                var validacion = eval("validarStep" + step + "()");
                if (validacion) {

                    $("body").spin("large");
                    x_sendForm($('#form_registro_medico_step' + step), true, function (data) {
                        //reseteamos el validador de contraseña
                        $("[data-meter='password_aut']").html("");
                        $("[data-meter='repassword_aut']").html("");
                        $("[data-meter='password_aut']").removeClass("veryweak");
                        $("[data-meter='password_aut']").removeClass("medium");
                        $("[data-meter='password_aut']").removeClass("strong");
                        $("[data-meter='repassword_aut']").removeClass("veryweak");
                        $("[data-meter='repassword_aut']").removeClass("medium");
                        $("[data-meter='repassword_aut']").removeClass("strong");
                        $("body").spin(false);
                        if (data.idmedico != undefined) {
                            $(".idmedico").val(data.idmedico);
                        }
                        if (data.result) {
                            $('#wizard_registro_medico').easyWizard('nextStep');
                        } else {
                            x_alert(data.msg);
                        }
                    });
                }
            });
        });
    });
    $(".btn-volver").click(function () {
        $('#wizard_registro_medico').easyWizard('prevStep');
        var step = $(this).data("prev");
        $("#span_steps").text(step + "/7");
    });
    $(".generateCodigoCelular").click(function () {
        $("#step2").spin("large");
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'generar_codigo_celular_registro_m.do',
                "idmedico=" + $(".idmedico").val(),
                function (data) {
                    $("#step2").spin("false");
                    if (data.result) {
                        x_alert(x_translate("En unos minutos recibirá un SMS con el código de valiación"));
                    } else {
                        x_alert(data.msg);
                    }

                }
        );
    });
    $(".button_gth").hide();
    $(':radio, :checkbox').radiocheck();
    $('.switch-checkbox').bootstrapSwitch();
    $('#btn-crear-cuenta').on('click', function (e) {
//se verifican los campos
        $.each($("#form input"), function (index, error) {
            var $element = $(error);
            $element.tooltip("destroy");
        });
        var step = $(this).data("step");
        x_sendForm($('#form_registro_medico_step' + step), true, function (data) {

            if (data.result) {

                $("#registroAccordon").slideUp();
                $("#mensajeRegistro").slideDown();
                scrollToEl($("body"));
            } else {
                x_alert(data.msg);
            }
        });
    });
    $("#refresh_captcha").click(function () {
        $('#captcha_img').attr('src', $('#url').val() + 'captcha.img?t=' + new Date().getTime());
    });
//listener cambio de especialidad 
    $("#especialidad_idespecialidad").on("change", function () {

        if ($("#pais_idpais").val() == 1) {

//verificar si la especialidad utiliza numero RPPS:0 , ADELI:1, Otro:2
            if ($("#especialidad_idespecialidad option:selected").data("identificacion") == 1) {
                $("#div_rpps").hide();
                $("#div_numero_identificacion").hide();
                $("#div_adeli").show();
                //
                $("#lbl_foto_cps").hide();
                $("#lbl_foto_titulo").hide();
                $("#lbl_foto_adeli").show();
            } else if ($("#especialidad_idespecialidad option:selected").data("identificacion") == 2) {
                $("#div_rpps").hide();
                $("#div_adeli").hide();
                $("#div_numero_identificacion").show();

                $("#lbl_foto_cps").hide();
                $("#lbl_foto_adeli").hide();
                $("#lbl_foto_titulo").show();

            } else {
                $("#div_rpps").show();
                $("#div_adeli").hide();
                $("#div_numero_identificacion").hide();
                //
                $("#lbl_foto_cps").show();
                $("#lbl_foto_adeli").hide();
                $("#lbl_foto_titulo").hide();
            }
        }
    });
    //mostrar contraseña
    $('.btnShowPassword').click(function () {
        if ($('#password_aut').attr('type') === "password") {
            $('#password_aut').attr('type', "text");
            $('#repassword_aut').attr('type', "text");
            $('.btnShowPassword').attr('title', x_translate("Ocultar contraseña"));
            $('.btnShowPassword i').removeClass('fa fa-eye').addClass('fa fa-eye-slash');
        } else {
            $('#password_aut').attr('type', "password");
            $('#repassword_aut').attr('type', "password");
            $('.btnShowPassword').attr('title', x_translate("Mostrar contraseña"));
            $('.btnShowPassword i').removeClass('fa fa-eye-slash').addClass('fa fa-eye');
        }
    });
    /*Accion eliminar archivo subido - tarjetas identificacion*/
    $(".btn-delete-file").click(function () {
        var hash = $(this).data("hash");
        var name = $(this).data("name");
        var tipo = $(this).data("tipo");
        var $btn = $(this);
        $("body").spin("large");
        x_doAjaxCall(
                'POST',
                BASE_PATH + 'common.php?action=1&modulo=upload&submodulo=upload_gen',
                "delete=1&hash=" + hash + "&name=" + name,
                function (data) {
                    $("body").spin(false);
                    if (data.result) {
                        $btn.closest(".upload-filename").hide();
                        $btn.closest(".pul-col-x2").find(".dz-clickable.upload-success").removeClass("upload-success");
                        $(".cont-imagen." + tipo).hide();
                    } else {
                        x_alert(data.msg);
                    }

                }
        );
    });
});
