<div class="form-wrapper mapc-registro-box pul-nuevo-paciente-accordion"> 
    <a href="{$url}portailsalariés.html" class="btn-volver-home-sante btn-ajuste-volver-empresa-front" ><i class="fa fa-chevron-left"></i></a>
    <form id="form_contratacion_plan" role="form" action="{$url}{$controller}.php?action=1&modulo=programa_salud_registro&submodulo=contratacion_plan" method="POST" onsubmit="return false;">
        <input type="hidden" id="plan_idplan" name="plan_idplan" value="" />
        <input type="hidden" id="tipo_plan" name="tipo_plan" value="" />
        <input type="hidden" id="particular" name="particular" value="1" />
        <input type="hidden" id="costo_plan" value="" />
        <input type="hidden" class="g-recaptcha-response" name="g-recaptcha-response" value="" />
        <div class="panel-body">
            <input type="hidden" name="password" id="password" value="" />
            <div class="okm-row">
                <div class="pul-col-x2">
                    <div class="mapc-input-line">
                        <label class="mapc-label">{"Nombre"|x_translate}</label>
                        <input type="text" id="nombre_input" name="nombre" />
                    </div>
                </div>
                <div class="pul-col-x2">
                    <div class="mapc-input-line">
                        <label class="mapc-label">{"Apellido"|x_translate}</label>
                        <input type="text"  id="apellido_input" name="apellido" />
                    </div>
                </div>
            </div>
            <div class="okm-row">
                <div class="pul-col-x2">

                    <div class="mapc-registro-form-row">
                        <label class="mapc-label">{"Email"|x_translate}</label>
                        <div class="mapc-input-line">
                            <input type="text" class="pul-np-dis" name="email" id="email_input" placeholder='{"ej: su-nombre@dominio.com"|x_translate}'/>
                            <i class="icon-doctorplus-envelope"></i>
                        </div>
                    </div>

                    <div class="mapc-registro-form-row">
                        <div class="mapc-input-line">
                            <input type="text" class="pul-np-dis" name="mail2" id="reemail_input" placeholder='{"Repita correo electrónico"|x_translate}'/>
                            <i class="icon-doctorplus-envelope"></i>
                        </div>
                    </div>

                </div>
                <div class="pul-col-x2">
                    <div class="mapc-registro-form-row">
                        <label class="mapc-label">{"Contraseña"|x_translate}</label>
                        <div class="mapc-input-line">
                            <input type="password" class="pul-np-dis input_password_strength" id="password_aut" placeholder='{"Contraseña de al menos 8 caracteres"|x_translate}'/>
                            <span class="btnShowPassword" title='{"Mostrar contraseña"|x_translate}'><i  class="fa fa-eye"></i></span>
                        </div>
                    </div>

                    <div class="mapc-registro-form-row">
                        <div class="mapc-input-line">
                            <input type="password" class="pul-np-dis input_password_strength" id="repassword_aut" placeholder='{"Repita contraseña"|x_translate}'/>
                            <span class="btnShowPassword" title='{"Mostrar contraseña"|x_translate}'><i  class="fa fa-eye"></i></span>
                        </div>
                    </div>

                </div>
            </div>

            <div class="okm-row">
                <div class="pul-col-x2">
                    <div class="mapc-registro-form-row">
                        <label class="mapc-label">{"Fecha de nacimiento"|x_translate}</label>
                        <div class="mapc-input-line">
                            <input type="text" id="fechaNacimiento_input" tabindex='4' name="fechaNacimiento" />
                            <i class="icon-doctorplus-calendar"></i>
                        </div>
                    </div>
                </div>
                <div class="pul-col-x2 " >
                    <div class="mapc-registro-form-row mapc-select pul-np-select">
                        <label class="mapc-label">{"Sexo"|x_translate}</label>
                        <select id="sexo" name="sexo"  class="form-control select select-primary select-block mbl pul-np-dis">
                            <option value="1" selected>{"HOMBRE"|x_translate}</option>
                            <option value="0" >{"MUJER"|x_translate}</option>
                        </select>
                    </div>
                </div>    
            </div>
            <div class="okm-row">
                <div class="pul-col-x2">
                    <div class="mapc-registro-form-row">
                        <label class="mapc-label">{"Celular"|x_translate}</label>
                        <div class="mapc-input-line">
                            <input type="tel" class="pul-np-dis" name="numeroCelular" tabindex='10' id="telefono_input" />
                            <i class="icon-doctorplus-cel"></i>

                        </div>
                    </div>
                </div>
                <div class="pul-col-x2">

                    <div class="mapc-registro-form-row cupon-descuento">
                        <label class="mapc-label">{"Si posee un cupón de descuento ingresalo aquí"|x_translate}</label>
                        <div class="mapc-input-line input-group" >
                            <span class="input-group-addon"><i class="fa fa-tag"></i></span>
                            <input type="text" class="pul-np-dis" name="cupon_descuento" id="cupon_descuento" />
                        </div>

                    </div>


                </div>
            </div>

            <!-- Terminos y condiciones + BTN registro -->
            <div class="okm-row">
                <div class="mapc-politicas-box" id="politicas">

                    <div class="mapc-politicas-check-box">
                        <div class="mapc-politicas-check-holder">
                            <label class="checkbox">
                                <input type="checkbox"  id="terminos_condiciones" value="1" name="terminos_condiciones" data-toggle="checkbox" class="custom-checkbox">
                            </label>
                        </div>
                        <div class="mapc-politicas">
                            <p>
                                <span>{"He leído y acepto los"|x_translate}&nbsp;</span>
                                <a href="{$url}Pass_bien-etre_Mentions_legales_et_CGUSV_-_Mai_2021.pdf"  rel="nofollow"  target="_blank"> {"Términos y condiciones de uso del sistema Pase de salud"|x_translate}</a>&nbsp;  
                                <span>{"así como el"|x_translate}&nbsp;</span>
                                <a href="{$url}Pass_bien-etre_Politique_Protection_des_donnees_-_Mai_2021.pdf"  rel="nofollow"  target="_blank"> {"Política de protección de datos del Pase de salud"|x_translate}</a>. 
                            </p>                                                        
                        </div>
                    </div>
                </div>
            </div>         

            <div class="okm-row">
                <div class="mapc-registro-form-row center">
                    <a href="javascript:;"  data-prev="2" class="btn-default btn-inverse btn-volver btn-volver-planes" style="background:#455a64">{"volver"|x_translate}</a>                                         
                    <a href="javascript:;" class="btn-default btn-crear-cuenta" data-step="1" >{"Crear una cuenta"|x_translate}</a>
                </div>
            </div>
        </div>

    </form>
    <div class="plogin-mensaje-registro" id="mensaje_validacion_celular">
        <input type="hidden" name="step" value="2" />
        <input type="hidden" id="idpaciente"  value="" />


        <div  id="cont_2">

            <div class="okm-row">
                <h3>{"Por su seguridad, le hemos enviado un mensaje con el código de uso único. Ingrese el código a continuación para continuar."|x_translate}</h3>

                <div class="pul-col-x2 form-element-center ">
                    <div class="mapc-input-line">
                        <label class="mapc-label">{"Código"|x_translate}</label>
                        <input type="text" id="codigo_input" tabindex='1' name="codigoValidacionCelular" maxlength="15"/>
                    </div>
                </div>

            </div>

            <div class="okm-row">
                <div class="mapc-politicas-box">

                    <div class="mapc-politicas-holder">
                        <figure>
                            <i class="icon-doctorplus-cel"></i>
                        </figure>
                        <div class="mapc-politicas">
                            <p>{"El mismo puede demorar unos minutos en llegar, aguarde. Si quiere generar el código nuevamente haga"|x_translate} <a href="javascript:;" class="generateCodigoCelular">{"click aquí"|x_translate}</a></p>
                        </div>
                    </div>

                </div>
            </div>

            <div class="okm-row">
                <div class="mapc-registro-form-row center">
                    <a href="javascript:;" class="btn-default validarCodigoCelular">{"Validar"|x_translate}</a>
                </div>
            </div>

        </div>

    </div>
    <div class="plogin-mensaje-registro" id="mensaje_registro_ok">
        <h3>{"Le hemos enviado un correo electrónico de confirmación en su bandeja de entrada."|x_translate}</h3>
        <div class="okm-row">
            <div class="mapc-registro-form-row center">
                <a href="javascript:;" class="btn-default btn-go-checkout" >{"siguiente"|x_translate}</a>
            </div>
        </div>
        <div class="okm-row">
            <p>
                {"A continuación, deberá validar su correo electrónico para acceder a su cuenta. Si no puede encontrarlo, es posible que este correo electrónico haya sido clasificado en la sección de spam de su bandeja de entrada."|x_translate}
            </p>
        </div>
    </div>
</div>
<!--	MODAL - Cuenta Particular pronto	-->


<script>
    var RECAPTCHA_PUBLIC = "{$RECAPTCHA_PUBLIC}";
</script>
<script src="https://www.google.com/recaptcha/api.js?hl=fr&render={$RECAPTCHA_PUBLIC}" async defer>
</script>
{literal}
    <script>
        $(function () {
            //plugin numero celular
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

            //opciones date picker de fecha de nacimiento
            $('#fechaNacimiento_input').mask("00/00/0000", {placeholder: "JJ/MM/AAAA"});
            //plugin dificultad password
            $('#password_aut,#repassword_aut').strength({
                strengthClass: 'input_password_strength',
                strengthMeterClass: 'strength_meter',
                strengthButtonClass: 'button_strength',
                strengthButtonText: 'Show Password',
                strengthButtonTextToggle: 'Hide Password'
            });
            $(".button_strength").hide();


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
            //recaptcha
            $("#refresh_captcha").click(function () {
                $('#captcha_img').attr('src', $('#url').val() + 'captcha.img?t=' + new Date().getTime());
            });

            //autocompletamos el dominio de la empresa cuando se completa el mail
            $("#email_input").blur(function () {
                //console.log("EMAIL:", $("#email_input").val());
                if ($("#email_input").val().indexOf("@") > 0) {
                    let dominio = $("#email_input").val().split("@");
                    //console.log("dominio", dominio);
                    $("#dominio_email").val(dominio[1]);
                }

            });

            $(".validarCodigoCelular").click(function () {
                var codigo = $("#codigo_input").val();
                $("body").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'frontend_2.php?action=1&modulo=programa_salud_registro&submodulo=beneficiario_particular_verificar_celular',
                        "codigoValidacionCelular=" + codigo + "&id=" + $("#idpaciente").val(),
                        function (data) {
                            $("body").spin(false);
                            if (data.result) {
                                $("#mensaje_validacion_celular").hide();
                                $("#mensaje_registro_ok").slideDown();
                                $("#codigo").val("");
                            } else {
                                x_alert(data.msg);
                            }


                        }
                );
            });

            $(".generateCodigoCelular").click(function () {
                $("body").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'generar_codigo_celular_registro_p.do',
                        "idpaciente=" + $("#idpaciente").val(),
                        function (data) {
                            $("body").spin(false);
                            if (data.result) {
                                x_alert(x_translate("En unos minutos recibirá un SMS con el código de valiación"));
                            } else {
                                x_alert(data.msg);
                            }

                        }
                );
            });



            var validarDatos = function () {

                //verificar nombre
                if ($("#nombre_input").val() == "") {
                    $("#nombre_input").data("title", x_translate("Ingrese su nombre")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#nombre_input").offset().top - 200}, 300);
                    return false;
                }

                //verificar apellido
                if ($("#apellido_input").val() == "") {
                    $("#apellido_input").data("title", x_translate("Ingrese su apellido")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#apellido_input").offset().top - 200}, 300);
                    return false;
                }
                //validar email
                //expresion regular para mail
                $("#email_input").val($("#email_input").val().trim());
                $("#reemail_input").val($("#reemail_input").val().trim());
                if (!validarEmail($("#email_input").val())) {
                    $("#email_input").data("title", x_translate("Ingrese un email válido")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#email_input").offset().top - 200}, 300);
                    return false;
                }
                if ($("#reemail_input").val() == "") {
                    $("#reemail_input").data("title", x_translate("Reingrese su email")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#reemail_input").offset().top - 200}, 300);
                    return false;
                }
                //coincidencia de los 2 email
                if ($("#email_input").val() != $("#reemail_input").val()) {
                    $("#reemail_input").data("title", x_translate("Las casillas de correo electrónico no coinciden")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#reemail_input").offset().top - 200}, 300);
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
                    }, 300);
                    return false;
                }

                if ($("#password_aut").val() == "") {
                    $("#password_aut").data("title", x_translate("Ingrese un contraseña")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#password_aut").offset().top - 200}, 300);
                    return false;
                }

                if ($("#repassword_aut").val() == "") {
                    $("#repassword_aut").data("title", x_translate("Reingrese su contraseña")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#repassword_aut").offset().top - 200}, 300);
                    return false;
                }

                var password1 = $.trim($('#password_aut').val());
                var password2 = $.trim($('#repassword_aut').val());
                if (password1 !== password2) {
                    $("#repassword_aut").data("title", x_translate("Las contraseñas no coinciden")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#repassword_aut").offset().top - 200}, 300);
                    return false;
                }
                //verificar fecha de nacimiento
                if ($("#fechaNacimiento_input").val().length != 10 || (typeof (validatedate) == "function" && !validatedate($("#fechaNacimiento_input").val()))) {
                    $("#fechaNacimiento_input").data("title", x_translate("Ingrese una fecha de nacimiento válida: DD/MM/AAAA")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#fechaNacimiento_input").offset().top - 200}, 1000);
                    return false;
                }



                //validar fecha futura
                var time_actual = new Date().getTime();
                var arr_split = $("#fechaNacimiento_input").val().split("/");
                var fecha_nac = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
                if (fecha_nac > time_actual) {
                    $("#fechaNacimiento_input").data("title", x_translate("La fecha de nacimiento no puede ser futura")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#fechaNacimiento_input").offset().top - 200}, 1000);
                    return false;
                }
                //validar mayor de edad
                var fecha_actual = new Date();
                var time_mayor_edad = fecha_actual.setFullYear(fecha_nac.getFullYear() + 18);
                if (time_mayor_edad > time_actual) {
                    $("#fechaNacimiento_input").data("title", x_translate("El paciente titular debe ser mayor de edad")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#fechaNacimiento_input").offset().top - 200}, 1000);
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
            $(".btn-crear-cuenta").click(function (e) {

                e.preventDefault();
                var step = $(this).data("step");
                grecaptcha.ready(function () {
                    grecaptcha.execute(RECAPTCHA_PUBLIC, {action: 'submit'}).then(function (token) {
                        $(".g-recaptcha-response").val(token);
                        //limpiamos los tooltip de validacion anteriores
                        $.each($('#form_contratacion_plan input'), function (index, error) {
                            var $element = $(error);
                            $element.tooltip("destroy");
                        });
                        $.each($('#form_contratacion_plan div'), function (index, error) {
                            var $element = $(error);
                            $element.tooltip("destroy");
                        });
                        var validacion = eval("validarDatos()");
                        if (validacion) {

                            $("body").spin("large");
                            x_sendForm($('#form_contratacion_plan'), true, function (data) {
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

                                if (data.result) {
                                    console.log("data", data);
                                    $(".btn-go-checkout").data("id", data.hash);
                                    scrollToEl($("body"));
                                    $("#form_contratacion_plan").hide();
                                    $("#idpaciente").val(data.idbeneficiario_particular);
                                    $("#mensaje_validacion_celular").fadeIn();
                                } else {
                                    x_alert(data.msg);
                                }
                            });
                        }
                    });
                });
            });
            //volver a los planes
            $(".btn-volver-planes").click(function () {
                $(".form-wrapper").hide();
                $(".planes-wrapper").fadeIn();
            });

            //boton siguiente - agregar tarjeta
            $(".btn-go-checkout").click(function () {
                if ($("#plan_idplan").val() == '21' || $("#plan_idplan").val() == '22' || $("#plan_idplan").val() == '23') {
                    $("#loginbtn").trigger("click");
                } else {
                    var id = $(this).data("id");
                    if (id !== "") {
                        $("body").spin("large");
                        let submodulo = "";
                        let params = "";
                        if ($("#tipo_plan").val() === "pack") {
                            submodulo = "checkout_pack_particular_form";
                        } else {
                            submodulo = "checkout_particular_form";
                        }
                        x_loadModule("programa_salud_registro", submodulo, "id=" + id, "checkout-container", BASE_PATH + "frontend_2").then(function () {
                            $("body").spin(false);
                            scrollToEl($("body"));
                            $(".creacion-cuenta").hide();
                            $(".registro-tarjeta").show();
                            $(".checkout-form").fadeIn();
                        });
                    }
                }


            });

        });
    </script>
{/literal}