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
    .inicial{
        margin-top: 70px;
    }
    .input-eyp{
        width: 300px;
        background-color: gainsboro;
        border-radius: 20px;
        padding-left: 15px;
        margin-top: 20px;
    }
    .alinear-restar-conectado{
        text-align: left;
        margin-left: 130px;
    }
    .btn-conectar{
        background: linear-gradient(180deg, #1f92b4, #2d75ad);
        color: white;
        width: 350px;
        border-radius: 15px;
        margin-top: 30px;
    }
    .btn-conectar:hover {
        color: white ;
    }
    .parrafo-texto{
        color: gainsboro;
        width: 300px;
        position: relative;
        left: 150px;
        line-height: 1.3;
        top: 150px; 
        font-size: 20px;
    }
    .container-log{
        display: flex;
    }
    .ubi-logo{
        position: relative;
        top: 150px;
        margin-left: 150px;
    }
    .container-banda-azul{
        margin-top: 20px;
    }
    .container-banda-gris{
        margin-top: 20px;
    }
    @media (max-width:600px){
        .container-log{

            flex-flow: row wrap-reverse;
        }
        .container-banda-azul{
            /**  position: relative;
              bottom: 410px; **/
            text-align: center;
            height: 140px;
            width: 100%;
            margin-top: 0px;
        }
        .container-banda-gris{
            position: relative;
            top: -30px;
            margin-top: 0px;
            padding-left: 0px;
            padding-right: 0px;
        }
        .ubi-logo{
            top: 0px;
            margin-left: 0px;
        }
        .parrafo-texto{
            width: 99%;
            left: 0px;
            top: 0px;
            font-size: 16px;
        }
        .row{
            margin-left: 0px ; 
            margin-right: 0px ;
        }
        .btn-sub{
            left: 13px;
            position: relative;
        }
        .parrafo-texto-pw{
            font-size: 14px !important;
        }
    }
</style>


<section class="okm-container" id="">
    <div style=" box-shadow: 0 3px 10px rgb(0 0 0 / 0.2);" class="row container-log">
        <div class="col-sm-6 container-banda-gris" style="text-align: center;">

            <div class="inicial">
                <h4 class="modal-title">{"Iniciar sesión"|x_translate}</h4>
                <form id="frm_login_form" action="{$url}login_step1.do" method="post" onsubmit="return false;">

                    <div class="login-form-row">
                        <input type="text" id="email_form" class="input-eyp" name="email" placeholder='{"Dirección de correo electrónico"|x_translate}' required="required" data-msg-required='{"Ingrese Email"|x_translate}'>
                        <i class="icon-doctorplus-envelope"></i>
                    </div>
                    <div class="login-form-row"  style="margin-bottom: 0px;">
                        <input id="password_form" name="password" value="" type="hidden" />
                        <input type="password" class="input-eyp" autocomplete="off" id="password_form_input" placeholder='{"Contraseña"|x_translate}' required="required" data-msg-required='{"Ingrese su contraseña"|x_translate}'>
                        <span id="btnShowPassword" title='{"Mostrar contraseña"|x_translate}'><i  class="fa fa-eye"></i></span>
                    </div>
                    <div class="error-row" style="display:none; font-size: 14px;">
                        <span class="red error-msg"></span>
                    </div>

                    <div class="login-form-row"  style="margin-top: 16px;">
                        <div class="login-recordar alinear-restar-conectado">
                            <label class="checkbox">
                                <input type="checkbox" id="recordarme">
                                {"Recordarme"|x_translate}
                            </label>
                        </div>
                    </div>

                    <div class="login-form-row" >
                        <input type="submit" id="enviar_codigo_verificacion_login" class="btn-conectar btn-sub" value='{"Inicia sesión"|x_translate}'/>
                    </div>

                    <div class="login-form-row"  style="margin-bottom: 20px;">
                        <div class="olvide-pass text-center" style="margin-top: 10px;">
                            <a href="#" class="ForgotPassTrigger" style="color: red; text-decoration: revert;" title='{"Olvidé mi contraseña"|x_translate}'>{"Olvidé mi contraseña"|x_translate}</a>
                        </div>
                    </div>
                    {**
                    <div class="login-registro-row" style="display: grid; margin-top: 40px">
                    <span style="font-weight: 600;">{"¿No tenés una cuenta?"|x_translate}</span>
                    <a class="btn-conectar" style="margin-bottom: 50px; margin-top: 10px; margin-left: 107px; height: 40px; line-height: 2; font-weight: 500; background: #F29100 !important;" href="{$url}creer-un-compte.html">{"Registrate"|x_translate}</a>
                    </div>
                    **}
                    <!-- fix exclude hubspot-->
                    <label for="cc-num" class="hidden">exclude form</label>
                    <input name="cc-num" class="hidden" required="" value="HubspotCollectedFormsWorkaround" id="cc-num">
                </form>
                <form id="frm_login_form_step2"  style="display:none;" action="{$url}login_step2.do" method="post" onsubmit="return false;">

                    <input type="hidden"  name="password"/>
                    <input type="hidden"  name="email"/>
                    <input type="hidden"  name="recordar"/>
                    <div class="login-form-row">

                        <div class="">
                            <p style="margin-top: 20px; font-size: 20px;"> {"Por su seguridad, le hemos enviado un mensaje con el código de uso único. Ingrese el código a continuación para continuar."|x_translate}</p>
                            <p style="font-size: 14px;"> {"El mismo puede demorar unos minutos en llegar, aguarde. Si quiere generar el código nuevamente haga"|x_translate} <a href="javascript:;" class="reenviar_codigo_verificacion_login">{"click aquí"|x_translate}</a></p>
                            <p id="codReenviado" style="font-size: 14px; color: red;"> {"Codigo reenviado."|x_translate} </p>
                        </div>
                    </div>
                    <div class="login-form-row" style="margin-bottom: 0px;">
                        <input type="text" id="codigo_verificacion_login_form" class="input-eyp" name="codigoVerificacionLogin" placeholder='{"Código de verificación"|x_translate}' required="required" data-msg-required='{"Ingrese Email"|x_translate}'>
                        <i class="icon-doctorplus-tel"></i>
                    </div>
                    <div class="error-row" style="display:none; font-size: 14px; ">
                        <span class="red error-msg"></span>
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
                    <!-- fix exclude hubspot-->
                    <label for="cc-num" class="hidden">exclude form</label>
                    <input name="cc-num" class="hidden" required="" value="HubspotCollectedFormsWorkaround" id="cc-num">
                    <div class="login-form-row" style="margin-top: 16px;">
                        <input type="submit" id="submit_login_form"  style="margin-bottom: 20px"  class="btn-conectar" value='{"Entrer"|x_translate}'/>

                    </div>

                </form>





                <!--				recuperar contraseña-->
                <div class="modal-body" id="passrecovery">
                    <h4 class="modal-title">{"Restablecer tu contraseña"|x_translate}</h4>
                    <form name="pass-recovery" id="frm_reset_pass_drop_down" action="{$url}reset_password.do" method="post" onsubmit="return false;">
                        <!-- fix exclude hubspot-->
                        <label for="cc-num" class="hidden">exclude form</label>
                        <input name="cc-num" class="hidden" required="" value="HubspotCollectedFormsWorkaround" id="cc-num">
                        <div class="login-form-row" style="margin-bottom: 0px;">
                            <input type="text" name="email" id="email_recuperar_drop_down" class="input-eyp" placeholder='{"Dirección de correo electrónico"|x_translate}' required="required" data-msg-required='{"Ingrese Email"|x_translate}'>
                            <i class="icon-doctorplus-envelope"></i>
                        </div>
                        <div class="error-row" style="display:none; font-size: 14px;">
                            <span class="red error-msg"></span>
                        </div>
                        <div class="login-form-row" style="margin-top: 16px;">
                            <p style="font-size: 14px;">
                                {"Introduce la dirección de correo electrónico asociada a tu cuenta y te enviaremos un enlace para restablecer tu contraseña."|x_translate} 
                            </p>
                        </div>
                        <div class="login-form-row">

                            <input type="submit" id="submit_reset_pass" style="margin-bottom: 20px"  class="btn-conectar" value='{"Enviar enlace"|x_translate}'/>

                            <!--send ok muestra siguiente paso, ahora está forzado al click en script.js linea 1314-->
                        </div>
                        <!-- fix exclude hubspot-->
                        <label for="cc-num" class="hidden">exclude form</label>
                        <input name="cc-num" class="hidden" required="" value="HubspotCollectedFormsWorkaround" id="cc-num">
                    </form>
                </div>




            </div>
        </div>

        <div class="col-sm-6 container-banda-azul" style="background: linear-gradient(180deg, #1f92b4, #2d75ad); ">
            <a class="ubi-logo" title="WorknCare">
                <img style="width: 200px;" src="{$IMGS}logo_workcnare_blanco.png" alt="WorknCare"/>
            </a>
            <p class="parrafo-texto">{"Le portail des salariés por utiliser leur Pass."|x_translate} </p>
            <p id="mensajeEnviadoRecuPw" class="parrafo-texto parrafo-texto-pw" style="display: none; ">{"Se ha enviado un email para que recupere su contraseña"|x_translate} </p>

        </div>
    </div>

</section>


{literal}

    <script>



        $(function () {


            $(document).ready(function () {
                $("#codReenviado").css('display', 'none');
            });


            $('.usrlogin.login').on('hidden.bs.modal', function () {
                //console.log("limpiar session storage");
                //limpiamos las variabes del session storage de cualquier reserva si se cancela el login
                sessionStorage.removeItem('tipo_reserva');
                sessionStorage.removeItem('idreserva');
                $(".error-row .error-msg").text("");
                $(".error-row").hide();
                $(".usrlogin.login input[type='text']").val("");
                $(".usrlogin.login input[type='password']").val("");
                $(".usrlogin.login input[type='recordar']").val("1");
                $(".usrlogin.login #recordarme").radiocheck("check");
            });

            $('.usrlogin.login').on('show.bs.modal', function () {
                $(".error-row .error-msg").text("");
                $(".error-row").hide();
                $(".usrlogin.login input[type='password']").val("");
                $(".usrlogin.login input[type='recordar']").val("1");
                $(".usrlogin.login #recordarme").radiocheck("check");
            });

            //submit login - step 1
            $("#enviar_codigo_verificacion_login").click(function () {
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
                x_sendForm($('#frm_login_form'), true, alert_resultado_step1);

            });
            //process resultado step 1 - lenviar codigo login
            function alert_resultado_step1(data) {
                $("body").spin(false);
                if (data.result) {
                    if (data.hasOwnProperty('usuario_logueado') && data.usuario_logueado === true) {
                        x_alert(x_translate("Usted ya tiene una sesión iniciada"));
                        window.location.href = "";
                    } else {
                        $("#frm_login_form").hide();
                        $("#frm_login_form_step2").show();
                    }
                } else {

                    if (!data.hasOwnProperty('field')) {
                        x_alert(x_translate(data.msg));
                    } else {
                        $("#frm_login_form .error-row .error-msg").text(x_translate(data.msg));
                        $("#frm_login_form .error-row").slideDown();

                    }
                }
            }

            //submit login - step 2
            $("#submit_login_form").click(function () {

                //limpiamos el mensaje de error
                $(".error-row .error-msg").text("");
                $(".error-row").hide();

                if ($("#codigo_verificacion_login_form").val() == "") {
                    $("#frm_login_form_step2 .error-row .error-msg").text(x_translate("El código de verificación no es válido"));
                    $("#frm_login_form_step2 .error-row").slideDown();
                    return false;
                }


                $("#frm_login_form_step2 input[name='password']").val($("#password_form").val());
                $("#frm_login_form_step2 input[name='email']").val($("#email_form").val());
                $("#frm_login_form_step2 input[name='recordar']").val($(".usrlogin.login #recordarme").is(":checked") ? 1 : 0);

                $("body").spin("large");
                x_sendForm($('#frm_login_form_step2'), true, alert_resultado_step2);

            });



            //process resultado step 2 - loguear usuario
            function alert_resultado_step2(data) {
                if (data.result) {
                    $("#mensaje-confirmacion").show();
                    setTimeout(function () {
                        if (data.redirect !== "" && data.redirect !== null) {
                            window.location.href = BASE_PATH + data.redirect;
                        } else {
                            sessionStorage.setItem("reserva_publica", true);
                            if (data.usuario == "paciente") {
                                window.location.href = BASE_PATH + "panel-paciente/";
                            } else if (data.usuario == "medico") {
                                window.location.href = BASE_PATH + "panel-medico/";
                            }
                        }
                    }, 1000);

                } else {
                    $("body").spin(false);
                    /*$("#frm_login_form_step2 input[name='password']").val();
                     $("#frm_login_form_step2 input[name='email']").val();
                     $("#codigo_verificacion_login_form").val();
                     $("#frm_login_form_step2").hide();
                     $("#frm_login_form").show();
                     */
                    $("#frm_login_form_step2 .error-row .error-msg").text(x_translate(data.msg));
                    $("#frm_login_form_step2 .error-row").slideDown();

                }
            }

            //reenviar codigo de login
            $(".reenviar_codigo_verificacion_login").click(function () {
                $("#codReenviado").css('display', 'block');

                $("body").spin("large");

                x_sendForm($('#frm_login_form'), true, function (data) {
                    $("body").spin(false);


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





            $('#loginbtn,#loginbtn2,#loginbtn3').on('click', function (e) {

                $("#frm_login_form").show();
                $("#frm_login_form_step2").hide();
                $("#codigo_verificacion_login_form").val("");
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

            //process resultado - reset contraseña
            function alert_resultado_reset(data) {

                $("body").spin(false);
                if (data.result) {

                    $("#mensajeEnviadoRecuPw").css('display', 'block');
                    $("#email_recuperar_drop_down").val("");
                    //  $(".login").modal("hide");
                } else {
                    $("#frm_reset_pass_drop_down .error-row .error-msg").text(x_translate(data.msg));
                    $("#frm_reset_pass_drop_down .error-row").slideDown();
                }
            }
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
<script>
</script>