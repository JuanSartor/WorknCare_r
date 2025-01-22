<style>
    .mapc-registro-box {
        margin: 10px auto;
    }
    .mapc-politicas-box {
        margin: 12px auto;
    }
    .mapc-politicas-box .mapc-politicas p{
        color: #415b70;
        font-size: 14px;
        line-height: 18px;
        margin-bottom: 10px;
    }
    .mapc-registro-form-row .btn-siguiente,.mapc-registro-form-row .btn-crear-cuenta{
        width:auto !important;
    }
    .mapc-registro-form-row .btn-volver{
        min-width:auto !important;
        width:auto !important;
    }
    .mapc-registro-form-row .btn-volver:hover{
        background: #b6b6b6 !important;
    }
    @media (max-width: 600px){
        .plogin-registro-accordios-title {
            font-size: 13px;
            padding: 8px;
        }
    }
    .mapc-select {
        margin-top: 0px;
    }
    .mapc-select .mbl{
        margin-bottom: 0px;
    }
    .plogin-mensaje-registro p {
        margin: auto auto 24px;
    }
    .plogin-mensaje-registro .plogin-mensaje-registro-actions{
        margin-bottom: 24px;
    }
    /*mostrar contraseña*/
    .mapc-input-line>.btnShowPassword{
        font-size: 24px;
        line-height: 22px;
        display: inline-block;
        position: absolute;
        top: 19px;
        right: 22px;
        /*color: #d8d8d8;*/
    }

    .btnShowPassword i {
        cursor:pointer;
    }
    /*archivos identificacion*/
    .cont-imagen{
        width:165px;
        height: 80px;
    }
    .cont-imagen.pdf{
        width:80px;
        height: 80px;
    }
    .upload-filename label{
        display:inline
    }
    .upload-filename .btn-delete-file {
        color: #f33243;
    }
    .card-logo-socio{
        position: relative;
        left: 310px;
        bottom: 30px;
    }
    @media (max-width: 600px){
        .card-pass{
            position: relative;
            right: 90px;
        }
        .card-logo-socio{
            left: 90px;
        }

    }
    @media (min-width: 600px){
        .logo-workncare{
            width: 120px !important;
            height: 25px !important;
        }

    }
</style>
<link href="{$url}xframework/app/themes/dp02/css/pass_esante_registro.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet">
{include file="paciente/menu_beneficiario.tpl"}

{include file="home/login.tpl"}


<div class="plogin-header">
    <h1>{"Crear una cuenta como"|x_translate}</h1>
    <h2>{"Beneficiario"|x_translate}</h2>
    <h3>{"Para beneficiarse de consultas gratuitas!"|x_translate}</h3>
</div>

<section  class="plogin-registro">



    <div id="registroAccordon" class="mapc-registro-box pul-nuevo-paciente-accordion">


        <h4 class="plogin-registro-accordios-title">{"REGISTRARME COMO BENEFICIARIO"|x_translate} <span id="span_steps" class="pull-right visible-xs">1/3</span></h4>

        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
            <div class="panel panel-default">

                <div class="row">
                    <div class="col-md-12 portlets">
                        <!-- Your awesome content goes here -->
                        <div class="widget animated fadeInDown">

                            <div id="wizard_registro_paciente">
                                <section class="step"  data-step-title="" data-callback='step1' >
                                    <form id="form_registro_beneficiario_step1" role="form" action="{$url}{$controller}.php?action=1&modulo=paciente&submodulo=beneficiario_registracion" method="POST" onsubmit="return false;">
                                        <input type="hidden" name="step" value="1" />
                                        <input type="hidden" id="pass_esante_cod" name="pass_esante" value="{$smarty.request.pass_esante}" />
                                        <input type="hidden" class="g-recaptcha-response" name="g-recaptcha-response" value="" />
                                        <div id="cont_1">
                                            <div class="panel-body">
                                                <input type="hidden" name="password" id="password" value="" />
                                                <div class="okm-row">
                                                    <div class="pul-col-x2">

                                                        <div class="mapc-registro-form-row">
                                                            <label class="mapc-label">{"Correo electrónico personal"|x_translate}</label>
                                                            <div class="mapc-input-line">
                                                                <input type="text" class="pul-np-dis" name="email" tabindex='7' id="email_input" placeholder='{"ej: su-nombre@dominio.com"|x_translate}'/>
                                                                <i class="icon-doctorplus-envelope"></i>
                                                            </div>
                                                        </div>

                                                        <div class="mapc-registro-form-row">
                                                            <div class="mapc-input-line">
                                                                <input type="text" class="pul-np-dis" name="mail2"  tabindex='8' id="reemail_input" placeholder='{"Repita correo electrónico"|x_translate}'/>
                                                                <i class="icon-doctorplus-envelope"></i>
                                                            </div>
                                                        </div>

                                                    </div>
                                                    <div class="pul-col-x2">
                                                        <div class="mapc-registro-form-row">
                                                            <label class="mapc-label">{"Celular"|x_translate}</label>
                                                            <div class="mapc-input-line">
                                                                <input type="tel" class="pul-np-dis" name="numeroCelular" tabindex='10' id="telefono_input" />
                                                                <i class="icon-doctorplus-cel"></i>

                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>


                                                <div class="okm-row">
                                                    <div class="pul-col-x2">

                                                        <div class="mapc-registro-form-row">
                                                            <label class="mapc-label">{"Contraseña"|x_translate}</label>
                                                            <div class="mapc-input-line">
                                                                <input type="password" class="pul-np-dis input_password_strength" tabindex='8' id="password_aut" placeholder='{"Contraseña de al menos 8 caracteres"|x_translate}'/>
                                                                <span class="btnShowPassword" title='{"Mostrar contraseña"|x_translate}'><i  class="fa fa-eye"></i></span>
                                                            </div>
                                                        </div>

                                                        <div class="mapc-registro-form-row">
                                                            <div class="mapc-input-line">
                                                                <input type="password" class="pul-np-dis input_password_strength" tabindex='9' id="repassword_aut" placeholder='{"Repita contraseña"|x_translate}'/>
                                                                <span class="btnShowPassword" title='{"Mostrar contraseña"|x_translate}'><i  class="fa fa-eye"></i></span>
                                                            </div>
                                                        </div>

                                                    </div>

                                                </div>           
                                                <div class="okm-row">  
                                                    <div class="pul-col-x2">
                                                        <div class="mapc-registro-form-row">
                                                            <label class="mapc-label">{"Idioma predeterminado"|x_translate}</label>
                                                            <!-- 1 frances 2 ingles -->
                                                            <input   {if $TRADUCCION_IDIOMA=="fr"} value="1" {else} value="2" {/if}  id="idioma_pre" name="idioma_pre" hidden>

                                                            {include file="paciente/select_idioma.tpl"}

                                                        </div>
                                                    </div>
                                                </div>
                                                <div class="okm-row pass-sante-registro-planes">
                                                    <div class="card-pass-sante">
                                                        <div class="card">
                                                            <div class="card-logo {if $empresa.image!=''} card-pass {/if}">
                                                                <img class="logo-workncare"  src="{$IMGS}logo_workncare_color.png"/>
                                                            </div>
                                                            {if $empresa.image!=''}
                                                                <div class="card-logo card-logo-socio">
                                                                    <img  style="width: 50px; height: 50px;" src="{$empresa.image.perfil}?t={$smarty.now}"/>
                                                                </div>
                                                            {/if}
                                                            <h4 class="title">{"Código del Plan de Salud"|x_translate} </h4>
                                                            <div class="text-center">
                                                                <input class="codigo codigo_pass" id="codigo_pass_input" maxlength="6" type="text" name="codigo_pass"/>
                                                            </div>
                                                            <p>
                                                                {"El código de acceso le permite beneficiarse de las condiciones de soporte en nuestra plataforma."|x_translate}
                                                            </p>
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
                                                                    <a href="{$url}Mentions_legales_et_CGUSV.pdf"  rel="nofollow"  target="_blank"> {"Términos y condiciones de uso del sistema"|x_translate}</a>&nbsp;                                                
                                                                    <span>{"así como el"|x_translate}&nbsp;</span>
                                                                    <a href="{$url}Notice_d_information_et_de_consentement_DP.pdf"  rel="nofollow"  target="_blank">{"Consentimiento del usuario"|x_translate}</a>.
                                                                </p>                                                        
                                                            </div>
                                                        </div>
                                                    </div>
                                                </div>         

                                                <div class="okm-row">
                                                    <div class="mapc-registro-form-row center">
                                                        <a href="javascript:;" class="btn-default btn-siguiente" data-step="1" >{"siguiente"|x_translate}</a>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>
                                    </form>
                                </section>
                                <section class="step" data-step-title="" data-callback='step2'> 
                                    <form id="form_registro_beneficiario_step2" role="form" action="{$url}{$controller}.php?action=1&modulo=paciente&submodulo=beneficiario_registracion" method="POST" onsubmit="return false;">
                                        <input type="hidden" name="step" value="2" />
                                        <input type="hidden" class="idpaciente" name="idpaciente" value="" />


                                        <div  id="cont_2">

                                            <div class="okm-row">
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
                                                            <p>{"Por su seguridad, le hemos enviado un mensaje con el código de uso único. Ingrese el código a continuación para continuar."|x_translate}</p>
                                                            <p>{"El mismo puede demorar unos minutos en llegar, aguarde. Si quiere generar el código nuevamente haga"|x_translate} <a href="javascript:;" class="generateCodigoCelular">{"click aquí"|x_translate}</a></p>

                                                        </div>
                                                    </div>

                                                </div>
                                            </div>

                                            <div class="okm-row">
                                                <div class="mapc-registro-form-row center">
                                                    <a href="javascript:;"  data-prev="1" class="btn-default btn-inverse btn-volver" style="background:#455a64">{"volver"|x_translate}</a>
                                                    <a href="javascript:;" class="btn-default btn-siguiente" data-step="2" >{"siguiente"|x_translate}</a>

                                                </div>
                                            </div>

                                        </div>
                                    </form>
                                </section>
                                <section class="step" data-step-title="" data-callback='step3'> 
                                    <form id="form_registro_beneficiario_step3" role="form" action="{$url}{$controller}.php?action=1&modulo=paciente&submodulo=beneficiario_registracion" method="POST" onsubmit="return false;">
                                        <input type="hidden" name="step" value="3" />
                                        <input type="hidden" class="idpaciente" name="idpaciente" value="" />

                                        <div  id="cont_3">

                                            <div class="okm-row">
                                                <div class="pul-col-x2">
                                                    <div class="mapc-input-line">
                                                        <label class="mapc-label">{"Nombre"|x_translate}</label>
                                                        <input type="text" id="nombre_input" tabindex='1' name="nombre" maxlength="15"/>
                                                    </div>
                                                </div>
                                                <div class="pul-col-x2">
                                                    <div class="mapc-input-line">
                                                        <label class="mapc-label">{"Apellido"|x_translate}</label>
                                                        <input type="text"  id="apellido_input" tabindex='2'name="apellido" maxlength="20" />
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
                                                <div class="mapc-registro-form-row center">
                                                    <a href="javascript:;"  data-prev="2" class="btn-default btn-inverse btn-volver" style="background:#455a64">{"volver"|x_translate}</a>
                                                    <a href="javascript:;" class="btn-default btn-crear-cuenta" data-step="3" >{"crear cuenta"|x_translate}</a>
                                                </div>
                                            </div>

                                        </div>
                                    </form>
                                </section>


                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>

    </div>
    <div class="plogin-mensaje-registro" id="mensajeRegistro">
        <h3 id="msjeRegistroNormalh3">{"¡Gracias por registrarse en DoctorPlus!"|x_translate}</h3>
        <h3 id="msjeRegistroExBeneficiarioh3" hidden>{"¡Gracias por utilizar WorknCare!"|x_translate}</h3>
        <h4 id="msjeRegistroNormal" >{"Se le ha enviado un email, siga los pasos indicados para activarla."|x_translate}</h4>
        <h4 id="msjeRegistroExBeneficiario" hidden >{"Su solicitud a sido enviada a la empresa, debe esperar su aprovacion!"|x_translate}</h4>

        <div class="plogin-mensaje-registro-actions">
            <a href="{$url}portailsalaries" class="btn-default btnVolver">{"volver"|x_translate}</a>
        </div>
        <p>
            {"Recuerde poner a resguardo su información personal de ingreso al sistema (usuario y contraseña), la necesitará para administrar su cuenta."|x_translate}<br> 
            {"Existen aplicaciones para smartphones y tablets que sirven para almacenar y cuidar todas las claves de modo seguro."|x_translate}
        </p>

    </div>
</section>


<script>
    var RECAPTCHA_PUBLIC = "{$RECAPTCHA_PUBLIC}";
</script>
<script src="https://www.google.com/recaptcha/api.js?hl=fr&render={$RECAPTCHA_PUBLIC}&data-badge=inline&data-size=invisible" async defer>
</script>

{literal}
    <script>
        $(function () {
            var step1 = function () {
                scrollToEl($("body"));
                $("#span_steps").text("1/3");
            };
            var step2 = function () {
                scrollToEl($("body"));
                $("#span_steps").text("2/3");
                //$("#codigo_input").inputmask("*****");
            };
            var step3 = function () {
                scrollToEl($("body"));
                $("#span_steps").text("3/3");
            };



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
                    $("#password_aut").data("title", x_translate("Ingrese una contraseña")).tooltip("show");
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
                //verificar codigo pass estanté
                if ($("#codigo_pass_input").val() == "") {
                    $("#codigo_pass_input").data("title", x_translate("Ingrese su código de beneficiario del Pass de Salud")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#codigo_pass_input").offset().top - 200}, 1000);
                    return false;
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

                return true;
            };


            $(document).ready(function () {


                $('#wizard_registro_paciente').easyWizard({
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
                $('.codigo_pass').mask("000000", {placeholder: "______"});
                //agregamos el + al numero de telefono
                $("#telefono_input").on("keyup", function () {
                    if ($(this).val().substring(0, 1) != "+") {
                        $(this).val("+" + $(this).val());
                    }
                });
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
                            $.each($('#form_registro_beneficiario_step' + step + ' input'), function (index, error) {
                                var $element = $(error);
                                $element.tooltip("destroy");
                            });
                            $.each($('#form_registro_beneficiario_step' + step + ' div'), function (index, error) {
                                var $element = $(error);
                                $element.tooltip("destroy");
                            });
                            var validacion = eval("validarStep" + step + "()");
                            if (validacion) {

                                $("body").spin("large");
                                x_sendForm($('#form_registro_beneficiario_step' + step), true, function (data) {
                                    $("body").spin(false);
                                    if (data.idpaciente != undefined) {
                                        $(".idpaciente").val(data.idpaciente);
                                    }
                                    //reseteamos el validador de contraseña
                                    $("[data-meter='password_aut']").html("");
                                    $("[data-meter='repassword_aut']").html("");
                                    $("[data-meter='password_aut']").removeClass("veryweak");
                                    $("[data-meter='password_aut']").removeClass("medium");
                                    $("[data-meter='password_aut']").removeClass("strong");
                                    $("[data-meter='repassword_aut']").removeClass("veryweak");
                                    $("[data-meter='repassword_aut']").removeClass("medium");
                                    $("[data-meter='repassword_aut']").removeClass("strong");
                                    if (data.result) {
                                        if ($("#sin_beneficios_reintegro").is(":checked")) {
                                            $("#registroAccordon").slideUp();
                                            $("#mensajeRegistro").slideDown();
                                            scrollToEl($("body"));
                                        } else {
                                            $('#wizard_registro_paciente').easyWizard('nextStep');
                                        }
                                    } else {
                                        if (data.banderainvitacion == 1) {
                                            jConfirm({
                                                title: x_translate("Confirmar Registro"),
                                                text: x_translate('Su mail se encuentra registrado como particular, ha recibido una invitacion. ¿Desea cambiar a beneficiario?'),
                                                confirm: function () {
                                                    $("body").spin("large");
                                                    x_doAjaxCall(
                                                            'POST',
                                                            BASE_PATH + 'frontend_2.php?action=1&modulo=paciente&submodulo=beneficiario_registracion',
                                                            "banderaBeneficiarioExistente=1" + "&pass_esante=" + $("#pass_esante_cod").val() + "&email=" + $("#email_input").val(),
                                                            function (data) {
                                                                $("body").spin(false);
                                                                if (data.result) {

                                                                    $("#registroAccordon").slideUp();
                                                                    $("#mensajeRegistro").slideDown();
                                                                    $("#msjeRegistroNormal").hide();
                                                                    $("#msjeRegistroExBeneficiario").show();
                                                                    $("#msjeRegistroNormalh3").hide();
                                                                    $("#msjeRegistroExBeneficiarioh3").show();
                                                                    scrollToEl($("body"));

                                                                } else {
                                                                    x_alert(data.msg);
                                                                }
                                                            }
                                                    );
                                                },
                                                cancel: function () {
                                                    x_alert(x_translate("Debe cambiar su email, ya se encuentra registrado"));
                                                },
                                                confirmButton: x_translate("Si"),
                                                cancelButton: x_translate("No")
                                            });
                                        } else {
                                            x_alert(data.msg);
                                        }
                                    }
                                });
                            }
                        });
                    });
                });

                $(".btn-volver").click(function () {
                    var step = $(this).data("prev");
                    if ($(this).data("prev") != undefined) {
                        $('#wizard_registro_paciente').easyWizard('goToStep', step);
                    } else {
                        $('#wizard_registro_paciente').easyWizard('prevStep');
                    }
                    $("#span_steps").text(step + "/6");
                });


                $(".generateCodigoCelular").click(function () {
                    $("#step2").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'generar_codigo_celular_registro_p.do',
                            "idpaciente=" + $(".idpaciente").val(),
                            function (data) {
                                $("#step2").spin(false);
                                if (data.result) {
                                    x_alert(x_translate("En unos minutos recibirá un SMS con el código de valiación"));
                                } else {
                                    x_alert(data.msg);
                                }

                            }
                    );
                });
                //$("#DNI_input").inputmask("99999999");

                $(".button_gth").hide();
                $(':radio, :checkbox').radiocheck();
                $('.switch-checkbox').bootstrapSwitch();
                $('#trabaja_otro_pais_si').on('change.radiocheck', function () {
                    // Do something
                    $("#div_tarjeta_cns").show();
                    $("#div_no_trabajo_luxemburgo").show();
                    $('#no_trabajo_luxemburgo').radiocheck('uncheck');
                });
                $('#trabaja_otro_pais_no').on('change.radiocheck', function () {
                    // Do something
                    $("#div_tarjeta_cns").hide();
                    $("#div_no_trabajo_luxemburgo").hide();
                    $('#no_trabajo_luxemburgo').radiocheck('uncheck');
                });

                $('.btn-crear-cuenta').on('click', function (e) {
                    //se verifican los campos
                    $.each($("#form input"), function (index, error) {
                        var $element = $(error);
                        $element.tooltip("destroy");
                    });

                    var step = $(this).data("step");
                    x_sendForm($('#form_registro_beneficiario_step' + step), true, function (data) {

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
                //opciones date picker de fecha de nacimiento
                $('#fechaNacimiento_input').mask("00/00/0000", {placeholder: "JJ/MM/AAAA"});

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

            });
        });
    </script>		
{/literal}