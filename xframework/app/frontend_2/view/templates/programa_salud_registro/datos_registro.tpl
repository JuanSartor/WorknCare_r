<div class="form-wrapper mapc-registro-box pul-nuevo-paciente-accordion"> 
    <a href="{$url}" class="btn-volver-home-sante btn-ajuste-volver-empresa-front" ><i class="fa fa-chevron-left"></i></a>
    <form id="form_contratacion_plan" role="form" action="{$url}{$controller}.php?action=1&modulo=programa_salud_registro&submodulo=contratacion_plan" method="POST" onsubmit="return false;">
        <input type="hidden" id="plan_idplan" name="plan_idplan" value="" />
        <input type="hidden" id="tipo_plan" name="tipo_plan" value="" />
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
                        <label class="mapc-label">{"Email profesional"|x_translate}</label>
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

                <div class="pul-col-x2" id="container_empresa_input">

                    <div class="mapc-registro-form-row">
                        <label class="mapc-label">{"Su empresa o establecimiento"|x_translate}</label>
                        <div class="mapc-input-line">
                            <input type="text" class="pul-np-dis" name="empresa" id="empresa_input" />
                        </div>
                    </div>
                </div>
                <div class="pul-col-x2">

                    <div class="mapc-registro-form-row">
                        <label class="mapc-label">{"Dominio de correo electronico de su empresa"|x_translate}&nbsp;*</label>
                        <div class="mapc-input-line input-group" >
                            <span class="input-group-addon" >@</span>
                            <input type="text" class="pul-np-dis" name="dominio_email" id="dominio_email" />
                        </div>

                    </div>

                </div>
            </div>
            <div class="okm-row" id="cant_empleados_container">

                <div class="pul-col-x2">
                    <div class="mapc-registro-form-row">
                        <label class="mapc-label">{"Cantidad de pack adquiridos"|x_translate}</label>
                        <div class="mapc-input-line input-group" >
                            <span class="input-group-addon button menos-cant" id="menos-cant" ><i class="fa fa-minus"></i></span>
                            <input type="number" class="pul-np-dis" name="cant_empleados" id="cant_empleados" style="text-align: center;"/>
                            <span class="input-group-addon button mas-cant" id="mas-cant"><i class="fa fa-plus"></i></span>
                        </div>

                    </div>
                </div>
                <div class="pul-col-x2">
                    <div class="mapc-registro-form-row">
                        <label class="mapc-label">{"Precio total de pack adquiridos"|x_translate}</label>
                        <div class="precio-total-pack">

                        </div>
                    </div>
                </div>
            </div>
            <div class="okm-row">
                <div class="pul-col-x2 adhesion-input">

                    <div class="mapc-registro-form-row">
                        <label class="mapc-label">{"Fecha de adhesión"|x_translate}&nbsp;*</label>
                        <div class="mapc-input-line">
                            <input type="text" class="pul-np-dis" name="fecha_adhesion" id="fecha_adhesion_input" />
                        </div>

                    </div>
                    <div class="mapc-registro-form-row">
                        <div class="label-aclaracion">
                            <span>*</span>
                            {"Solo empezarás a pagar cuando tienes al menos un beneficiario del Plan de Salud, es decir, cuando haya abierto una cuenta en nuestra plataforma DoctorPlus"|x_translate}
                        </div>
                    </div>
                </div>
                <div class="pul-col-x2 cupon-input">
                    <!--
                                        <div class="mapc-registro-form-row cupon-descuento">
                                            <label class="mapc-label">{"Si posee un cupón de descuento ingresalo aquí"|x_translate}</label>
                                            <div class="mapc-input-line input-group" >
                                                <span class="input-group-addon"><i class="fa fa-tag"></i></span>
                                                <input type="text" class="pul-np-dis" name="cupon_descuento" id="cupon_descuento" />
                                            </div>
                    
                                        </div>
                    
                    -->
                </div>
            </div>

            <div class="pul-col-x2">

                <div class="mapc-registro-form-row">
                    <label class="mapc-label">{"Idioma predeterminado"|x_translate}</label>
                    <!-- 1 frances 2 ingles -->

                    <input {if $TRADUCCION_IDIOMA=="fr"} value="1" {else} value="2" {/if} id="idioma_pre" name="idioma_pre" hidden>
                    {include file="programa_salud_registro/select_idioma.tpl"}

                </div>


            </div>
            <div class="okm-row" id="tipo_cuenta_container">

                <div class="tipo-cuenta-box"  {if $free =='1'} style="display: none;" {else} style="display:flex;" {/if}>

                    <label class="radio mapc-label" for="tipo_cuenta_empresa" style="width:50%;">
                        <input type="radio" data-toggle="radio" value="1" checked="checked" id="tipo_cuenta_empresa" name="tipo_cuenta" class="custom-checkbox">
                        {"Soy empresa"|x_translate}
                    </label>
                    <label class="radio mapc-label" for="tipo_cuenta_particular" style="width:50%;" >
                        <input type="radio" data-toggle="radio" value="2" id="tipo_cuenta_particular" name="tipo_cuenta"  class="custom-checkbox">
                        {"Soy un particular"|x_translate}
                    </label>
                </div> 
            </div>


            <div class="okm-row" id="tipo_cuenta_empresarial">

                <div class="tipo-cuenta-box box-tipo-empresas">

                    <label class="radio mapc-label" for="tipo_cuenta_empresa_empresa" style="width:25%; padding-left: 35px;">
                        <input type="radio" data-toggle="radio" value="1" checked="checked" id="tipo_cuenta_empresa_empresa" name="tipo_cuenta_empresa" class="custom-checkbox">
                        <span class="radibutton-texto-tipoempresa"> {"Empresa"|x_translate} </span>
                    </label>
                    <label class="radio mapc-label" for="tipo_cuenta_empresa_cse" style="width:25%; padding-left: 35px;" >
                        <input type="radio" data-toggle="radio" value="2" id="tipo_cuenta_empresa_cse" name="tipo_cuenta_empresa"  class="custom-checkbox">
                        <span class="radibutton-texto-tipoempresa">{"CSE/COS"|x_translate}</span>
                    </label>
                    <label class="radio mapc-label" for="tipo_cuenta_empresa_comunidad" style="width:25%; padding-left: 35px;" >
                        <input type="radio" data-toggle="radio" value="3" id="tipo_cuenta_empresa_comunidad" name="tipo_cuenta_empresa"  class="custom-checkbox">
                        <span class="radibutton-texto-tipoempresa"> {"Comunidad"|x_translate}</span>
                    </label>
                    <label class="radio mapc-label" for="tipo_cuenta_asociacion" style="width:25%; padding-left: 35px;" >
                        <input type="radio" data-toggle="radio" value="4" id="tipo_cuenta_asociacion" name="tipo_cuenta_empresa"  class="custom-checkbox">
                        <span class="radibutton-texto-tipoempresa"> {"Asociacion"|x_translate}</span>
                    </label>
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


<div id="modal-cuenta-particular" class="modal fade bs-example-modal-lg vc-modal-interrupcion vc-refund-modal" tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel">
    <div class="modal-dialog modal-lg" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><i class="fa fa-times"></i></span></button>
            </div>
            <div class="modal-body">
                <figure class="modal-icon"><i class="fa fa-user"></i></figure>
                <h3 class="modal-sub-title">{"Programa de bienestar para particulares"|x_translate}</h3>
                <h4 class="modal-title">{"¿Desea cambiar el tipo de contratación a un plan particular para usted?"|x_translate}</h4>
            </div>
            <div class="modal-footer">
                <div class="modal-action-row">
                    <a href="javascript:;" class="btn-alert" data-dismiss="modal" >{"cancelar"|x_translate}</a>

                    <a href="{$url}portailsalariés.html" class="btn-default" >{"cambiar"|x_translate}</a>
                </div>
            </div>
        </div>
    </div>
</div>
<script>
    var RECAPTCHA_PUBLIC = "{$RECAPTCHA_PUBLIC}";</script>
<script src="https://www.google.com/recaptcha/api.js?hl=fr&render={$RECAPTCHA_PUBLIC}" async defer>
</script>
{literal}
    <script>
        $(function () {

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
            //verificamos dominio empresa para email de beneficiarios:
            $("#dominio_email").data("title", x_translate("Proporcione el dominio de correo electronico de su empresa para asegurar que sus beneficiarios se registraran con su  correo electronico personal y no utilizaran su correo empresarial")).tooltip({trigger: 'focus '});
            //quitamos el @ 
            $("#dominio_email").on("keyup", function () {
                if ($(this).val().indexOf("@") >= 0) {
                    $(this).val($(this).val().replace("@", ""));
                    x_alert(x_translate("Debe ingresar solo el dominio de correo electronico de su empresa que se encuentra seguido del @"));
                    return false;
                }
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
            //opciones date picker de fecha de nacimiento
            $('#fecha_adhesion_input').mask("00/00/0000", {placeholder: "JJ/MM/AAAA"});
            //fix año solo con 2 cifras
            $("#fecha_adhesion_input").blur(function () {
                if ($(this).val().indexOf("/") >= 0) {
                    let fecha_split = $("#fecha_adhesion_input").val().split("/");
                    //console.log("fecha_split", fecha_split);
                    if (typeof fecha_split[2] == "string" && fecha_split[2].length == 2) {
                        fecha_split[2] = "20" + fecha_split[2];
                        $("#fecha_adhesion_input").val(fecha_split[0] + "/" + fecha_split[1] + "/" + fecha_split[2]);
                    }
                }
            });
            //mostrar ocultar campo empresa
            $('#tipo_cuenta_empresa').on('change.radiocheck', function () {
                // console.log("empresa");
                $("#container_empresa_input").show();
                $("#tipo_cuenta_empresarial").show();
            });
            $('#tipo_cuenta_particular').on('change.radiocheck', function (e) {
                //    console.log("particular");
                $("#tipo_cuenta_empresarial").hide();
                e.preventDefault();
                //$("#container_empresa_input").hide();
                //$("#empresa_input").val("");

                //deshabilitado al comiento - Vendrá pronto
                $("#modal-cuenta-particular").modal("show");
                //$("#tipo_cuenta_empresa").radiocheck("check");
            });
            //listener modificar cantidad pack
            $(".mas-cant,.menos-cant").click(function () {
                let actual_val = parseInt($("#cant_empleados").val());
                if (isNaN(actual_val)) {
                    return false;
                }

                if ($(this).hasClass("mas-cant")) {
                    $("#cant_empleados").val(++actual_val);
                } else {
                    idplan = $("#plan_idplan").val();
                    if (idplan == 20) {
                        // si es el plan 500 enterprise no puede tener menos de 500
                        if (actual_val > 500) {
                            $("#cant_empleados").val(--actual_val);
                        }
                    } else {
                        //minimo 1 pack, no seguimos restando 
                        if (actual_val > 1) {
                            $("#cant_empleados").val(--actual_val);
                        }
                    }
                }
                $("#cant_empleados").trigger("change");
            }
            );
            //detectamos el cambio de la cantidad y recalculamos el total
            $("#cant_empleados").change(function () {
                if (isNaN(parseInt($("#costo_plan").val())) || isNaN(parseInt($("#cant_empleados").val()))) {
                    return false;
                }
                $(".precio-total-pack").html("€" + parseInt($("#costo_plan").val()) * parseInt($("#cant_empleados").val()));
            });
            var validarDatos = function () {

                idplan = $("#plan_idplan").val();
                if (idplan == 21 || idplan == 22 || idplan == 23) {
                    $(".texto-21-22").hide();
                }
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

                if ($("#dominio_email").val() == "") {
                    $("#dominio_email").data("title", x_translate("Ingrese el dominio de correo electronico de su empresa")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#dominio_email").offset().top - 200}, 300);
                    return false;
                }
                //verificar fecha de nacimiento
                idplan = $("#plan_idplan").val();
                if (idplan != 22 && idplan != 21 && idplan != 23) {
                    if ($("#fecha_adhesion_input").val().length != 10 || (typeof (validatedate) == "function" && !validatedate($("#fecha_adhesion_input").val()))) {
                        $("#fecha_adhesion_input").data("title", x_translate("Ingrese una fecha de adhesión válida: DD/MM/AAAA")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#fecha_adhesion_input").offset().top - 200}, 300);
                        return false;
                    }
                }

                //validar fecha pasada
                if (idplan != 22 && idplan != 21 && idplan != 23) {
                    var fecha_actual = new Date(new Date().getFullYear(), new Date().getMonth(), new Date().getDate());
                    var arr_split = $("#fecha_adhesion_input").val().split("/");
                    var fecha_adhesion = new Date(parseInt(arr_split[2]), parseInt(arr_split[1] - 1), parseInt(arr_split[0]));
                    if (fecha_adhesion.getTime() < fecha_actual.getTime()) {
                        $("#fecha_adhesion_input").data("title", x_translate("La fecha de adhesion no puede ser anterior a hoy")).tooltip("show");
                        $('html, body').animate({
                            scrollTop: $("#fecha_adhesion_input").offset().top - 200}, 300);
                        return false;
                    }
                }
                if ($("#tipo_cuenta_empresa").is(":checked") && $("#empresa_input").val() === "") {
                    $("#empresa_input").data("title", x_translate("Debe ingresar el nombre de su empresa")).tooltip("show");
                    $('html, body').animate({
                        scrollTop: $("#empresa_input").offset().top - 200}, 300);
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
                                    $("#mensaje_registro_ok").fadeIn();
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
                            submodulo = "checkout_pack_form";
                        } else {
                            submodulo = "checkout_form";
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