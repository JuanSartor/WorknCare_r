<style>
    #btnShowPassword i {
        cursor:pointer;
    }
    #password_form_input:not(:placeholder-shown) + span i {
        color: #415b70 !important;
    }
    #mensaje-confirmacion .login-registro-row {
        display: flex;
        align-items: center;
        margin-top: 20px;
    }
    #mensaje-confirmacion .animationContainer{
        width: 30px;
        display: inline-block;
        margin-right: 10px;
    }
</style>
<div class="modal fade usrlogin login  loginEmpresa" {if $free =='1'} style="display: none;" {/if} tabindex="-1" role="dialog" aria-labelledby="myLargeModalLabel" data-keyboard="false" data-backdrop="static">
    <div class="modal-dialog modal-sm" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close"  title='{"Cerrar"|x_translate}' data-dismiss="modal" aria-label="Close"><span aria-hidden="true"><i class="fa fa-times"></i></span></button>
            </div>
            <div class="modal-body" id="login">
                <h4 class="modal-title">{"Iniciar sesión"|x_translate}</h4>
                <form id="frm_login_form" action="{$url}frontend_2.php?action=1&modulo=login&submodulo=login_empresa" method="post" onsubmit="return false;">
                    <!-- fix exclude hubspot-->
                    <label for="cc-num" class="hidden">exclude form</label>
                    <input name="cc-num" class="hidden" required="" value="HubspotCollectedFormsWorkaround" id="cc-num">
                        <div class="login-form-row">
                            <input type="text" id="email_form" name="email" placeholder='{"Dirección de correo electrónico"|x_translate}' required="required" data-msg-required='{"Ingrese Email"|x_translate}'>
                                <i class="icon-doctorplus-envelope"></i>
                        </div>
                        <div class="login-form-row"  style="margin-bottom: 0px;">
                            <input id="password_form" name="password" value="" type="hidden" />
                            <input type="password" autocomplete="off" id="password_form_input" placeholder='{"Contraseña"|x_translate}' required="required" data-msg-required='{"Ingrese su contraseña"|x_translate}'>
                                <span id="btnShowPassword" title='{"Mostrar contraseña"|x_translate}'><i  class="fa fa-eye"></i></span>
                        </div>
                        <div class="error-row" style="display:none; font-size: 14px;">
                            <span class="red error-msg"></span>
                        </div>

                        <div class="login-form-row" style="margin-top: 16px;">
                            <input type="submit" id="submit_login_form"  value='{"Entrer"|x_translate}'/>

                        </div>
                        <div class="login-form-row"  >
                            <div class="olvide-pass text-center">
                                <a href="#" class="ForgotPassTrigger" title='{"Olvidé mi contraseña"|x_translate}'>{"Olvidé mi contraseña"|x_translate}</a>
                            </div>
                        </div>

                        <div id="mensaje-confirmacion" style="display:none;">

                            <div class="login-registro-row">
                                <div class="animationContainer animated rubberBand">
                                    <svg version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" x="0px" y="0px" viewBox="0 0 85 82" xml:space="preserve">
                                        {literal}
                                            <style type="text/css">
                                                .st00{fill:#EAEAEA;}
                                                .st10{clip-path:url(#SVGID_2_);fill:none;stroke:#6A6F72;stroke-width:80;stroke-linecap:round;stroke-miterlimit:10;}
                                                .st20{fill:none;stroke:#00E7B6;stroke-width:5;stroke-linecap:round;stroke-miterlimit:10;}
                                                .st30{fill:none;stroke:#BA4343;stroke-width:5;stroke-linecap:round;stroke-miterlimit:10;}
                                            </style>
                                        {/literal}
                                        <g>
                                            <path class="st20 CVKuhQYc_0" d="M67.6,19.5c0.2,0.2,0.4,0.5,0.6,0.7c0.2,0.2,0.4,0.5,0.6,0.7c4.2,5.5,6.7,12.5,6.7,20c0,18.2-14.8,33-33,33
                                                  s-33-14.8-33-33s14.8-33,33-33c9.4,0,17.9,3.9,23.9,10.3c0.3,0.4,0.7,0.7,1,1.1"></path>
                                            <path class="st20 CVKuhQYc_1" d="M66.9,19.8L35.3,51.3L23,39"></path>
                                        </g>
                                        {literal}
                                            <style>.CVKuhQYc_0{stroke-dasharray:208 210;stroke-dashoffset:209;animation:CVKuhQYc_draw 100ms ease-out 0ms forwards;}.CVKuhQYc_1{stroke-dasharray:63 65;stroke-dashoffset:64;animation:CVKuhQYc_draw 100ms ease-out 100ms forwards;}@keyframes CVKuhQYc_draw{100%{stroke-dashoffset:0;}}@keyframes CVKuhQYc_fade{0%{stroke-opacity:1;}92.5925925925926%{stroke-opacity:1;}100%{stroke-opacity:0;}}
                                            </style>
                                        {/literal}
                                    </svg>
                                </div>


                                <span>{"Cargando su cuenta"|x_translate}<span class="loading-label-animation"></span></span>
                            </div>

                        </div>



                </form>



            </div>

            <!--				recuperar contraseña-->
            <div class="modal-body" id="passrecovery">
                <h4 class="modal-title">{"Restablecer tu contraseña"|x_translate}</h4>
                <form name="pass-recovery" id="frm_reset_pass_drop_down" action="{$url}frontend_2.php?action=1&modulo=home&submodulo=reset_pass_empresa" method="post" onsubmit="return false;">
                    <!-- fix exclude hubspot-->
                    <label for="cc-num" class="hidden">exclude form</label>
                    <input name="cc-num" class="hidden" required="" value="HubspotCollectedFormsWorkaround" id="cc-num">
                        <div class="login-form-row" style="margin-bottom: 0px;">
                            <input type="text" name="email" id="email_recuperar_drop_down" placeholder='{"Dirección de correo electrónico"|x_translate}' required="required" data-msg-required='{"Ingrese Email"|x_translate}'>
                                <i class="icon-doctorplus-envelope"></i>
                        </div>
                        <div class="error-row" style="display:none; font-size: 14px;">
                            <span class="red error-msg"></span>
                        </div>
                        <div class="login-form-row" style="margin-top: 16px;">
                            <p>
                                {"Introduce la dirección de correo electrónico asociada a tu cuenta y te enviaremos un enlace para restablecer tu contraseña."|x_translate} 
                            </p>
                        </div>
                        <div class="login-form-row">

                            <input type="submit" id="submit_reset_pass" value='{"Enviar enlace"|x_translate}'/>

                            <!--send ok muestra siguiente paso, ahora está forzado al click en script.js linea 1314-->
                        </div>

                </form>
            </div>


        </div>

    </div>
</div>


{literal}

    <script>



        $(function () {

            $('.usrlogin.login').on('hidden.bs.modal', function () {
                $(".error-row .error-msg").text("");
                $(".error-row").hide();
                $(".usrlogin.login input[type='text']").val("");
                $(".usrlogin.login input[type='password']").val("");
            });

            $('.usrlogin.login').on('show.bs.modal', function () {
                $(".error-row .error-msg").text("");
                $(".error-row").hide();
                $(".usrlogin.login input[type='password']").val("");
            });

            //submit login - step 1
            $("#submit_login_form").click(function () {
                //limpiamos el mensaje de error
                $(".error-row .error-msg").text("");
                $(".error-row").hide();

                if ($("#email_form").val() == "" || $('#password_form_input').val() == "") {
                    $("#frm_login_form .error-row .error-msg").text(x_translate("Usuario incorrecto. Verifique los datos ingresados"));
                    $("#frm_login_form .error-row").slideDown();
                    return false;

                }

                //password encode
                var password = $.trim($('#password_form_input').val());
                var valor = Base64.encode(SHA1(password));
                $("#password_form").val(valor);

                $("body").spin("large");
                x_sendForm($('#frm_login_form'), true, alert_resultado_step);

            });

            //loguear usuario
            function alert_resultado_step(data) {
                if (data.result) {
                    $("#mensaje-confirmacion").show();
                    setTimeout(function () {
                        window.location.href = BASE_PATH + "entreprises/";

                    }, 1000);

                } else {
                    $("body").spin(false);
                    $("#frm_login_form .error-row .error-msg").text(x_translate(data.msg));
                    $("#frm_login_form .error-row").slideDown();
                    if (data.suscripcion_pendiente == 1) {
                        finalizar_proceso_registro(data);
                    }

                }
            }

            function finalizar_proceso_registro(data) {
                if (data.contratacion_manual == 1) {
                    x_alert(x_translate("Suscripción pendiente de pago: Su contratacion del Pase de Bienestar se encuentra pendiente. Debe realizar la transferencia bancaria poder continuar el proceso"));
                    return false;
                } else {
                    jConfirm({
                        title: x_translate("Suscripción pendiente de pago"),
                        text: x_translate(data.msg),
                        confirm: function () {
                            $("body").spin();
                            if (data.hash !== "") {
                                $('.usrlogin.login').modal("hide");
                                $("body").spin("large");
                                let submodulo = "";

                                if (data.obra_social == 1) {
                                    submodulo = "checkout_pack_form";
                                } else {
                                    submodulo = "checkout_form";
                                }
                                x_loadModule("programa_salud_registro", submodulo, "id=" + data.hash, "checkout-container", BASE_PATH + "frontend_2").then(function () {
                                    $("body").spin(false);
                                    scrollToEl($("body"));
                                    $(".creacion-cuenta").hide();
                                    $(".registro-tarjeta").show();
                                    $(".checkout-form").fadeIn();
                                });
                            }
                        },

                        cancel: function () {
                        },
                        confirmButton: x_translate("Continuar"),
                        cancelButton: x_translate("Cancelar")
                    });
                }

            }
            //reenviar codigo de login
            $(".reenviar_codigo_verificacion_login").click(function () {
                //limpiamos el mensaje de error
                $(".error-row .error-msg").text("");
                $(".error-row").hide();

                $("body").spin("large");

                x_sendForm($('#frm_login_form'), true, function (data) {
                    $("body").spin(false);
                    x_alert(data.msg);

                });

            });

            //submit formulario - recuperar contraseña
            $("#submit_reset_pass").click(function () {
                //limpiamos el mensaje de error
                $(".error-row .error-msg").text("");
                $(".error-row").hide();
                if ($("#email_recuperar_drop_down").val() == "") {
                    $("#frm_reset_pass_drop_down .error-row .error-msg").text(x_translate("Email no válido"));
                    $("#frm_reset_pass_drop_down .error-row").slideDown();
                    return false;

                }
                $("body").spin("large");
                x_sendForm($('#frm_reset_pass_drop_down'), true, alert_resultado_reset);
            });


            //process resultado - reset contraseña
            function alert_resultado_reset(data) {
                $("body").spin(false);
                if (data.result) {
                    x_alert(x_translate("Se ha enviado un email para que recupere su contraseña"));

                    $("#email_recuperar_drop_down").val("");
                    $(".login").modal("hide");
                } else {
                    $("#frm_reset_pass_drop_down .error-row .error-msg").text(x_translate(data.msg));
                    $("#frm_reset_pass_drop_down .error-row").slideDown();
                }
            }


            $('#loginbtn').on('click', function (e) {

                $("#frm_login_form").show();
                $('#login').show();
                $('#passrecovery').hide();


            });

            $('#loginbtnEmpresa').on('click', function (e) {
                $('.loginEmpresa').modal('toggle');
                $("#frm_login_form").show();
                $('#login').show();
                $('#passrecovery').hide();
            });

            $('.ForgotPassTrigger').on('click', function (e) {
                e.preventDefault();
                $('#login').hide();

                $('#passrecovery').fadeIn();

            });

            //mostrar contraseña
            $('#btnShowPassword').click(function () {
                if ($('#password_form_input').attr('type') === "password") {
                    $('#password_form_input').attr('type', "text");
                    $('#btnShowPassword').attr('title', x_translate("Ocultar contraseña"));
                    $('#btnShowPassword i').removeClass('fa fa-eye').addClass('fa fa-eye-slash');
                } else {
                    $('#password_form_input').attr('type', "password");
                    $('#btnShowPassword').attr('title', x_translate("Mostrar contraseña"));
                    $('#btnShowPassword i').removeClass('fa fa-eye-slash').addClass('fa fa-eye');
                }
            });


        });
    </script>
{/literal}
{if $show_login=="1"}
    <script>
        let tipousuario_login = "{$tipousuario}";
        $(function () {

            $(".usrlogin #login").show();
            $(".usrlogin").modal("show");

        });

    </script>
{/if}