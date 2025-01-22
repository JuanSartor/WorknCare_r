<style>
    /*mostrar contraseña*/
    .form.edit .field-edit>.btnShowPassword{
        font-size: 24px;
        line-height: 22px;
        display: inline-block;
        position: absolute;
        top: 22px;
        right: 22px;
        /*color: #d8d8d8;*/
    }

    .btnShowPassword i {
        cursor:pointer;
    }
</style>
<!--	datos administrador-->
<link href="{$url}xframework/core/libs/libs_js/intl-tel-input/build/css/intlTelInput.css" rel="stylesheet" >
<div class="mul-datos-administrador-box">

    <section class="notification-settings form edit white">
        <div class="container">
            <div class="okm-row">
                <h2 class="text-center">{"Datos para uso del sistema"|x_translate}</h2>
                <p class="mul-alert">{"Estos datos no serán visibles para el paciente"|x_translate}</p>
            </div>	
            <div class="okm-row">
                <form id="f_save" name="f_save" action="{$url}panel-medico/datos-administrador/guardar_celular_email.do" method="POST" onsubmit="return false;">
                    <div class="col-md-5 col-md-offset-1">
                        <div class="field-edit border email">
                            <input type="text" maxlength="50" id="cambioEmail" name="email" placeholder='{"ejemplo@mail.com"|x_translate}' {if $medico.cambioEmail!=""}value="{$medico.cambioEmail}"{else}value="{$medico.email}"{/if}>

                        </div>
                        <small id="email_error" class="mul-input-error  hidden">{"Debe ingresar un email válido"|x_translate}</small>
                    </div>
                    <div class="col-md-5">
                        <div class="field-edit border smartphone">
                            <input type="tel" id="numeroCelular" name="numeroCelular"  value="{$medico.numeroCelular}">
                        </div>
                        <small id="celular_error" class="mul-input-error hidden">{"Debe ingresar un celular válido"|x_translate}</small>

                    </div>
                </form>
            </div>


            {*desplegable validar celular*}
            <div id="desplegable-validacion" class="relative">
                <div class="okm-row mul-slide-validar-box" id="mul-validar-cel">
                    <div class="validar-cell-box">
                        <h2>{"Validar celular"|x_translate} <a class="mul-validar-close-triger" href="javascript:;"><i class="icon-doctorplus-cruz"></i></a></h2>
                        <div class="validar-cell-content relative">
                            <span id="validar_cel_msg" class="validar-cell-telefono">
                                {"Le enviamos un SMS y un correo electrónico con el código de validación de su teléfono móvil al número"|x_translate}&nbsp;
                                {$medico.numeroCelular}.
                            </span>
                            <p>
                                {"Agregue este código para poder usar su cuenta normalmente. Este código puede tardar unos minutos en llegar a usted, ¡así que tenga cuidado! Si quieres generar un nuevo código"|x_translate} 
                                &nbsp;<a href="javascript:;" class="generateCodigoCelular">{"click aquí"|x_translate}</a> 
                            </p>
                            <div class="validar-cell-action-box">
                                <input type="text" class="codigo-cell" name="codigo-cell" placeholder='{"INGRESE CODIGO"|x_translate}'>
                            </div>
                            <div class="validar-cell-action-box">
                                <a href="javascript:;" class="btn-secondary-square  validarCodigoCelular">{"confirmar"|x_translate}</a>
                            </div>
                        </div>
                    </div>
                </div>

                {*desplegable  celular no validado*}
                {if $medico.numeroCelular!="" && $medico.celularValido=="0"}
                    <div class="okm-row mul-slide-validar-box relative" id="mul-validar-cel-revalidar">
                        <div class="validar-cell-box relative ">
                            <h2>{"Validar celular"|x_translate} <a class="mul-validar-close-triger" href="#"><i class="icon-doctorplus-cruz"></i></a></h2>
                            <div class="validar-cell-content">
                                <span class="validar-cell-telefono">{"Celular:"|x_translate} {$medico.numeroCelular}</span>
                                <p class="mul-red">
                                    {"Su número de celular aún no se encuentra validado y no podrá recibir notificaciones."|x_translate} 						</p>
                                <p>
                                    {"Si quiere generar el código nuevamente"|x_translate}&nbsp;
                                    <a href="javascript:;" class="generateCodigoCelular">{"click aquí"|x_translate}</a> 
                                </p>
                                <div class="validar-cell-action-box">
                                    <input type="text" class="codigo-cell " name="codigo-cell" placeholder='{"INGRESE CODIGO"|x_translate}'>
                                </div>
                                <div class="validar-cell-action-box">
                                    <a href="javascript:;" class="btn-secondary-square validarCodigoCelular">{"confirmar"|x_translate}</a>
                                </div>
                            </div>
                        </div>
                    </div>
                {/if}
                {*desplegable validar mail*}
                <div class="okm-row mul-slide-validar-box" id="mul-validar-mail">
                    <div class="validar-cell-box relative">
                        <h2>{"Validar casilla de correo"|x_translate} <a class="mul-validar-close-triger" href="javascript:;"><i class="icon-doctorplus-cruz"></i></a></h2>
                        <div class="validar-cell-content">
                            <span id="validar_mail_msg" class="validar-cell-telefono">{"Le enviamos un email con el código de validación de su email a la casilla"|x_translate} {$medico.cambioEmail}.
                            </span>
                            <p>
                                {"Deberá ingresarlo para un correcto funcionamiento del sistema. El mismo puede demorar unos minutos en llegar, aguarde. Recuerde revisar la bandeja de correo no deseado. Algunos servidores de correo pueden llegar a interpretar estos correos automáticos de forma incorrecta."|x_translate}
                            </p>
                            <p>
                                {"Si quiere que le enviemos nuevamente el email"|x_translate} <a href="javascript:;" class="generateCodigoEmail">{"click aquí"|x_translate}</a> 
                            </p>
                            <div class="validar-cell-action-box">
                                <input type="text" class="codigo-cell" name="codigo-cell" placeholder='{"INGRESE CODIGO"|x_translate}'>
                            </div>
                            <div class="validar-cell-action-box">
                                <a href="javascript:;" class="btn-secondary-square  validarCodigoEmail">{"confirmar"|x_translate}</a>
                            </div>
                        </div>
                    </div>
                </div>

                {*desplegable email no validado*}
                {if $medico.cambioEmail!="" && $medico.cambioEmail!=$medico.email} 
                    <div class="okm-row mul-slide-validar-box relative" id="mul-validar-mail-revalidar">
                        <div class="validar-cell-box relative">
                            <h2>{"Validar casilla de correo"|x_translate} <a class="mul-validar-close-triger" href="#"><i class="icon-doctorplus-cruz"></i></a></h2>
                            <div class="validar-cell-content">
                                <span class="validar-cell-telefono">{"Casilla de correo:"|x_translate} {$medico.cambioEmail}</span>
                                <p class="mul-red">
                                    {"Su casilla de correo aún no se encuentra validada."|x_translate} 						</p>
                                <p>
                                    {"Si quiere generar el código nuevamente"|x_translate} <a href="javascript:;" class="generateCodigoEmail">{"click aquí"|x_translate}</a> 
                                </p>
                                <div class="validar-cell-action-box">
                                    <input type="text" class="codigo-cell " name="codigo-cell" placeholder='{"INGRESE CODIGO"|x_translate}'>
                                </div>
                                <div class="validar-cell-action-box">
                                    <a href="javascript:;" class="btn-secondary-square validarCodigoEmail">{"confirmar"|x_translate}</a>
                                </div>
                            </div>
                        </div>
                    </div>
                {/if}

            </div>

            <div class="okm-row">
                <div class="mul-submit-box">
                    <button id="btnSaveDatos" class="save-data">{"Guardar"|x_translate}</button>
                    <p class="disclaimer text-center">
                        {"Consulte nuestra"|x_translate} 
                        <a href="{$url}Mentions_legales_et_CGUSV.pdf"  rel="nofollow"  target="_blank"> {"Términos y condiciones de uso del sistema"|x_translate}</a>&nbsp;                                                
                        <span>{"así como el"|x_translate}&nbsp;</span>
                        <a href="{$url}Notice_d_information_et_de_consentement_DP.pdf"  rel="nofollow"  target="_blank">{"Consentimiento del usuario"|x_translate}</a>.

                    </p>  
                </div>
            </div>
        </div>
    </section>

    <section class="password-change form edit">
        <div class="container">
            <h2 class="text-center">{"Contraseña"|x_translate}</h1>
                <div class="row">
                    <form id="f_pass" name="f_pass" action="{$url}panel-medico/datos-administrador/cambiar_password.do" autocomplete="off" method="post">

                        <input type="hidden" id="newPassword" name="newPassword"/>
                        <input type="hidden" id="rePassword" name="rePassword"/>
                        <input type="hidden" id="oldPassword" name="oldPassword"/>

                        <div class="col-md-5 col-md-offset-1" id="password-block">
                            <p class="mul-disclaimer-input">
                                {"Recuerde que la clave debe contener mínimo 6 dígitos."|x_translate}
                            </p>
                            <div class="mul-input-clave-box">
                                <div class="field-edit dp-lock">
                                    <input type="password" id="f_oldPassword"  maxlength="50" value="" placeholder='{"Contraseña anterior"|x_translate}'>
                                    <span class="btnShowPassword" title='{"Mostrar contraseña"|x_translate}'><i  class="fa fa-eye"></i></span>

                                </div>
                                <small id="oldpassword_error" class="validate error hidden"></small>

                            </div>
                            <div class="mul-input-clave-box">
                                <div class="field-edit dp-lock">
                                    <input type="password" id="f_newPassword" class="input_password_strength" maxlength="50" value="" placeholder='{"Establecer nueva contraseña"|x_translate}'>
                                    <span class="btnShowPassword" title='{"Mostrar contraseña"|x_translate}'><i  class="fa fa-eye"></i></span>

                                </div>
                                <small id="newpassword_error" class="validate error hidden"></small>
                            </div>
                            <div class="mul-input-clave-box">
                                <div class="field-edit dp-lock">
                                    <input type="password" id="f_rePassword"  class="input_password_strength" maxlength="50" value="" placeholder='{"Repita la nueva contraseña"|x_translate}'>
                                    <span class="btnShowPassword" title='{"Mostrar contraseña"|x_translate}'><i  class="fa fa-eye"></i></span>
                                </div>
                                <small id="repassword_error" class="validate error hidden"></small>
                            </div>
                        </div>
                    </form>
                    <div class="col-md-5 disclaimer mul-clave-disclaimer">
                        <p>
                            {"A la hora de elegir una clave, tenga en cuenta lo siguiente:"|x_translate}
                            <br />
                        </p>
                        <ul>
                            <strong>{"Clave Segura"|x_translate}</strong>
                            <li>- {"Única. No utilice siempre las mismas."|x_translate}</li>
                            <li>- {"Difícil de suponer y fácil de recordar."|x_translate}</li>
                            <li>- {"Largas, difíciles de deducir."|x_translate}</li>
                            <li>- {"Cámbiela con frecuencia."|x_translate}</li>
                            <li>- {"No las guarde en su PC. Memorícelas o use aplicaciones especificas."|x_translate}</li>
                            <li>{"Existen aplicaciones para smartphones y tablets que sirven para almacenar y cuidar todas las claves de modo seguro."|x_translate}</li>
                        </ul>
                        <p>
                        </p>
                        <ul>
                            <strong>{"Clave Vulnerable"|x_translate}</strong>
                            <li>{"No deben tener:"|x_translate}</li>
                            <li>- {"Tres o cuatro dígitos iguales."|x_translate}</li>
                            <li>- {"Los tres primeros o últimos dígitos de su documento."|x_translate}</li>
                            <li>- {"Números correlativos, ascendentes ni descendentes."|x_translate}</li>
                            <li>- {"Dos pares de números iguales."|x_translate}</li>                            
                            <li>- {"Números relacionados con fechas importantes"|x_translate}</li>
                        </ul>
                    </div>	

                </div>
        </div>
        <div class="mul-submit-box">
            <button id="btnSavePassword" class="save-data">{"Guardar"|x_translate}</button>
        </div>
    </section>
</div>	
<script src="{$url_js_libs}/intl-tel-input/build/js/intlTelInput.js"></script>
<script src="{$url_js_libs}/intl-tel-input/build/js/utils.js"></script>
{*si ingreso nuevamente y no esta validado el celular aun*}
{if $medico.numeroCelular!="" && $medico.celularValido=="0"}
    {literal}
        <script>
                    $(document).ready(function () {
                        $('#mul-validar-cel-revalidar').slideToggle();

                    });
        </script>
    {/literal}
{/if}

{*si ingreso nuevamente y no esta validado el mail aun*}
{if $medico.cambioEmail!="" && $medico.cambioEmail!=$medico.email}
    {literal}
        <script>
            $(document).ready(function () {
                $('#mul-validar-mail-revalidar').slideToggle();

            });
        </script>
    {/literal}
{/if}


{literal}
    <script>
        $("#numeroCelular").intlTelInput({
            nationalMode: false,
            preferredCountries: ['fr', 'be', 'lu'],
            utilsScript: BASE_PATH + "xframework/core/libs/libs_js/intl-tel-input/build/js/utils.js"
        });
        $("#numeroCelular").mask("+0000000000000");

        $(document).ready(function () {



            $('#f_newPassword,#f_rePassword').strength({
                strengthClass: 'input_password_strength',
                strengthMeterClass: 'strength_meter',
                strengthButtonClass: 'button_strength',
                strengthButtonText: 'Show Password',
                strengthButtonTextToggle: 'Hide Password'
            });

            $(".button_strength").hide();

            $(':radio, :checkbox').radiocheck();

            //CABMIO DE CONTRASEÑA
            $("#btnSavePassword").click(function () {
                //ocultamos los mensajes de error
                $("#oldpassword_error").addClass("hidden");
                $("#newpassword_error").addClass("hidden");
                $("#repassword_error").addClass("hidden");


                if ($('#f_oldPassword').val() == "") {
                    $("#oldpassword_error").html(x_translate("Ingrese la contraseña anterior"));
                    $("#oldpassword_error").removeClass("hidden");
                    return;
                }


                //Si el validador retorna que es muy débil la contraseña.
                if (!$("[data-meter='f_newPassword']").hasClass("strong")) {
                    //La contraseña es muy débil, debe tener al menos 8 caracteres
                    $("#newpassword_error").html(x_translate("La contraseña es muy débil, debe tener al menos 8 caracteres, una mayúscula y un número"));
                    $("#newpassword_error").removeClass("hidden");
                    return;
                }
                if ($('#f_newPassword').val() == "") {
                    $("#newpassword_error").html(x_translate("Ingrese la nueva contraseña"));
                    $("#newpassword_error").removeClass("hidden");
                    return;
                }

                if ($('#f_rePassword').val() == "") {
                    $("#repassword_error").html(x_translate("Repita la nueva contraseña"));
                    $("#repassword_error").removeClass("hidden");
                    return;
                }
                if ($('#f_rePassword').val() != $('#f_newPassword').val()) {
                    $("#repassword_error").html(x_translate("Las claves no coinciden"));
                    $("#repassword_error").removeClass("hidden");
                    return;
                }



                //ocultamos los mensajes de error si no hay error
                $("#oldpassword_error").addClass("hidden");
                $("#newpassword_error").addClass("hidden");
                $("#repassword_error").addClass("hidden");


                //codificamos las contraseñas antes de enviar
                $('#oldPassword').val(Base64.encode(SHA1($('#f_oldPassword').val())));
                $('#newPassword').val(Base64.encode(SHA1($('#f_newPassword').val())));
                $('#rePassword').val(Base64.encode(SHA1($('#f_rePassword').val())));
                x_sendForm(
                        $('#f_pass'),
                        true,
                        function (data) {
                            x_alert(data.msg);
                            if (data.result) {
                                $("#f_pass input").val("");
                            }



                        }
                );

            });

            //VALIDACION DE CELULAR
            //
            //reenvio de codigo
            $(".generateCodigoCelular").click(function () {
                $("#desplegable-validacion").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'generar_codigo_celular_m.do',
                        "",
                        function (data) {
                            if (data.result) {
                                x_alert(x_translate("En unos minutos recibirá un SMS con el código de valiación"));
                            } else {
                                x_alert(data.msg);
                            }
                            $("#desplegable-validacion").spin(false);
                        }
                );
            });
            //agregamos el + al numero de telefono
            $("#numeroCelular").on("keyup", function () {
                if ($(this).val().substring(0, 1) != "+") {
                    $(this).val("+" + $(this).val());
                }
            });

            //boton gurdar celular y email
            $("#btnSaveDatos").click(function () {
                //validar longitud celular
                $("#celular_error").addClass("hidden");


                if ($("#numeroCelular").val() == "") {

                    $("#celular_error").removeClass("hidden");
                    return false;
                } else {
                    if ($("#numeroCelular").intlTelInput("isValidNumber")) {
                        //ok
                    } else {
                        if ($("#numeroCelular").val().substring(0, 4) == "+337" && ($("#numeroCelular").val().length == 12)) {
                            //ok
                        } else {
                            $("#celular_error").removeClass("hidden");
                            return false;
                        }
                    }
                }

                //expresion regular para mail
                $("#email_error").addClass("hidden");
                if (!validarEmail($("#cambioEmail").val())) {
                    $("#email_error").removeClass("hidden");
                    return false;
                }

                $(".mul-slide-validar-box").hide();
                $("#Main").spin("large");
                x_sendForm(
                        $('#f_save'),
                        true,
                        function (data) {
                            $("#Main").spin(false);
                            x_alert(data.msg);

                            if (data.result && data.celularValido == "0") {
                                //seteamos el msg con el numero ingresado
                                $("#validar_cel_msg").html("Nous vous avons envoyé un SMS ainsi qu’un email avec le code de Validation de votre portable au numéro " + $("#numeroCelular").val());
                                $('#mul-validar-cel').slideToggle();
                            }
                            if (data.result && data.emailValido == "0") {
                                //seteamos el msg con el numero ingresado
                                $("#validar_mail_msg").html("Nous vous avons envoyé le code de vérification de votre compte  sur votre boite email " + $("#cambioEmail").val());
                                $('#mul-validar-mail').slideToggle();
                            }





                        }
                );
            });


            //validar el codigo de celular enviado por SMS
            $(".validarCodigoCelular").click(function () {
                var codigo = $(this).parent().siblings(".validar-cell-action-box").find("input").val();
                if (codigo == "") {
                    x_alert(x_translate("En unos momentos recibiras un SMS con el código de validación de tu celular."));

                } else {
                    $("#desplegable-validacion").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'validar_codigo_celular_m.do',
                            "codigoValidacionCelular=" + codigo,
                            function (data) {
                                $("#desplegable-validacion").spin(false);
                                x_alert(data.msg, recargar);

                            }
                    );
                }
            });

            //VALIDACION DEL NUEVO  EMAIL
            //validar el codigo de validacion enviado por mail
            $(".validarCodigoEmail").click(function () {
                var codigo = $(this).parent().siblings(".validar-cell-action-box").find("input").val();
                if (codigo == "") {
                    x_alert(x_translate("Ingrese el código que le enviamos por mail"));

                } else {
                    $("#desplegable-validacion").spin("large");
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + 'validar_codigo_email_m.do',
                            "codigoValidacionEmail=" + codigo,
                            function (data) {
                                $("#desplegable-validacion").spin(false);
                                x_alert(data.msg, recargar);

                            }
                    );
                }
            });

            //reenvio de codigo de email
            $(".generateCodigoEmail").click(function () {
                $("#desplegable-validacion").spin("large");
                x_doAjaxCall(
                        'POST',
                        BASE_PATH + 'generar_codigo_email_m.do',
                        "",
                        function (data) {
                            x_alert(data.msg);
                            $("#desplegable-validacion").spin(false);
                        }
                );
            });

            //desplegables

            $('.mul-validar-close-triger').on('click', function (e) {
                e.preventDefault();
                $(this).parent('h2').parent('.validar-cell-box').parent('.mul-slide-validar-box').slideUp();
            });

            //mostrar contraseña
            $('.btnShowPassword').click(function () {

                if ($('#f_oldPassword').attr('type') === "password") {
                    $('#f_oldPassword').attr('type', "text");
                    $('#f_newPassword').attr('type', "text");
                    $('#f_rePassword').attr('type', "text");
                    $('.btnShowPassword').attr('title', x_translate("Ocultar contraseña"));
                    $('.btnShowPassword i').removeClass('fa fa-eye').addClass('fa fa-eye-slash');
                } else {
                    $('#f_oldPassword').attr('type', "password");
                    $('#f_newPassword').attr('type', "password");
                    $('#f_rePassword').attr('type', "password");
                    $('.btnShowPassword').attr('title', x_translate("Mostrar contraseña"));
                    $('.btnShowPassword i').removeClass('fa fa-eye-slash').addClass('fa fa-eye');
                }
            });


        });
    </script>
{/literal}