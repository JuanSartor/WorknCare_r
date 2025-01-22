<link href="{$url_js_libs}xframework/core/libs/libs_js/intl-tel-input/build/css/intlTelInput.css" rel="stylesheet" type="text/css" />
<link href="{$url}xframework/app/themes/dp02/css/contactenos.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />

{include file="home_w/login.tpl"}

<div id="trigger-show-box-contacto"></div>
<section class="home-contacto-background">


    <div id="f_contacto_container" class="hom-contacto-box">
        <div class="form-contactenos reveal-box-contacto">
            <div id="hom-contacto-box" class="hom-contacto-form ">
                {* <h4 class="text-titulo-contactenos ">{"Contáctenos"|x_translate}</h4> *}
                <form id="f_contacto" name="hom-contacto" action="{$url}enviar_mail_contacto.do" method="POST" onsubmit="return false;">


                    <!-- <label>{"Nombre"|x_translate}<span>*</span></label> -->
                    <div  id="scroll-hom-contacto-container" class="form_name">
                        <div class="cont-input">
                            <label>{"Nombre"|x_translate}<span>*</span></label>
                            <input type="text" class="corto padding-btn-mobile" name="nombre" required="required"  >
                        </div>
                        <div class="cont-input">
                            <label>{"Apellido"|x_translate}<span>*</span></label> 
                            <input type="text" class="corto corto-segundo" name="apellido" required="required" >
                        </div>
                    </div>



                    <div class="hom-form-row">
                        <div class="cont-input">
                            <label>{"Email"|x_translate}<span>*</span></label> 
                            <input id="email_contacto" class="largo" type="text" name="email" required="required" >

                        </div>

                        <div class="cont-input">
                            <label>{"Teléfono"|x_translate}</label> 
                            <input type="tel" class="largo" id="telefono_contacto" name="telefono" placeholder="{"Teléfono"|x_translate}">

                        </div>

                    </div>

                    <div class="hom-form-row">
                        <div class="hom-form-col-x1 cont-input">
                            <label>{"Mensaje"|x_translate}</label> 
                            <textarea class="text-area" name="mensaje" required="required" ></textarea>
                        </div>
                    </div>
                    <div class="hom-form-row hom-form-action">
                        <button type="submit"  id="btnEnviarMailContacto" class="btn-default g-recaptcha btn-enviar-contacto"  data-callback='enviarMailContacto' data-badge="inline" data-action='submit' data-sitekey="{$RECAPTCHA_PUBLIC}">{"ENVIAR"|x_translate}</button>
                    </div>
                    <label for="cc-num" class="hidden">exclude form</label>
                    <input name="cc-num" class="hidden" required="" value="HubspotCollectedFormsWorkaround" id="cc-num">
                    <div class="clearfix">&nbsp;</div>
                </form>
                <img src="{$url}xframework/app/themes/dp02/img/contact_photo.jpg" class="logo-contacto" alt="DoctorPlus"></img>
            </div>
            <div id="hom-contacto-msg" class="hom-contacto-msg">
                <h4 class="text-titulo-contactenos">{"Su consulta ha sido enviada."|x_translate}</h4>
                <p>
                    {"Nos pondremos en contacto con usted a la brevedad"|x_translate}
                </p>
                <div class="clearfix">&nbsp;</div>
                <p>
                    <strong> {"El equipo de DoctorPlus"|x_translate}</strong>
                </p>
            </div>
        </div>  

    </div>

</section>

<div class="banner__separator">
    <p>{"Vous êtes Professionnel de santé, Coach ou prestataire ?"|x_translate}</p>
    <div style="display: flex;">
        <li style="margin-right: 10px;"><a  href="{$url}professionnel/creer-un-compte.html"  title='{"Je découvre"|x_translate}' >{"Je découvre"|x_translate}</a></li>
        <li style="margin-left: 10px;"> <a  href="{$url}medecin-ou-professionnel/?connecter"  title='{"Se connecter"|x_translate}' >{"Se connecter"|x_translate}</a></li>
    </div>
</div>
{* <div class="clearfix">&nbsp;</div> *}
<script src="https://www.google.com/recaptcha/api.js?hl=fr" async defer>

</script>
<script src="{$url}xframework/core/libs/libs_js/jquery/jquery.inputmask/jquery.inputmask.bundle.min.js">
</script>
<script src="{$url_js_libs}xframework/core/libs/libs_js/jQuery-Mask/dist/jquery.mask.min.js">
</script>
<script src="{$url_js_libs}xframework/core/libs/libs_js/intl-tel-input/build/js/intlTelInput.js">
</script>
<script src="{$url_js_libs}xframework/core/libs/libs_js/intl-tel-input/build/js/utils.js">
</script>
<script type="text/javascript" src="{$url_js_libs}xframework/core/libs/libs_js/scrollmagic/minified/TweenMax.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}xframework/core/libs/libs_js/scrollmagic/minified/ScrollMagic.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}xframework/core/libs/libs_js/scrollmagic/minified/plugins/jquery.ScrollMagic.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}xframework/core/libs/libs_js/scrollmagic/minified/plugins/animation.gsap.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}xframework/core/libs/libs_js/scrollmagic/minified/plugins/debug.addIndicators.min.js"></script>



{literal}
    <script>
        $(function () {
            //animacion aparecer con scroll
            // init controller
            var controller = new ScrollMagic.Controller();

            // create a scene
            new ScrollMagic.Scene({
                triggerElement: "#trigger-show-box-contacto", // y value not modified, so we can use element as trigger as well
                offset: 50, // start a little later
                triggerHook: 0.9,
            })
                    .setClassToggle(".reveal-box-contacto", "visible") // add class toggle
                    //.addIndicators({name: "reveal-box-contacto"}) // add indicators (requires plugin)
                    .addTo(controller);

            //plugin telefono
            $("#telefono_contacto").intlTelInput({
                nationalMode: false,
                preferredCountries: ['fr', 'be', 'lu'],
                utilsScript: BASE_PATH + "xframework/core/libs/libs_js/intl-tel-input/build/js/utils.js"
            });
            $("#telefono_contacto").mask("+0000000000000");

            //agregamos el + al numero de telefono
            $("#telefono_contacto").on("keyup", function () {
                if ($(this).val().substring(0, 1) != "+") {
                    $(this).val("+" + $(this).val());
                }
            });


        });
        //formulario envio mail conactto
        var enviarMailContacto = function (token) {

            // Clean up any tooltips for valid elements
            $("#f_contacto input:required").each(function () {
                if ($(this).val() == "") {
                    $(this).data("title", x_translate("Este campo es obligatorio"))
                            .tooltip("show");
                }
                return false;
            });

            if ($("#f_contacto textarea").val() == "") {
                $("#f_contacto textarea").data("title", x_translate("Este campo es obligatorio"))
                        .tooltip("show");

            }

            //expresion regular para mail
            if (!validarEmail($("#email_contacto").val())) {
                $("#email_contacto").data("title", x_translate("Ingrese un email válido"))
                        .tooltip("show");
                return false;
            }

            //si hay telefono verifico la longitud
            if ($("#telefono_input").val() != "") {
                if ($("#telefono_input").intlTelInput("isValidNumber")) {
                    //ok
                } else {
                    if ($("#telefono_input").val().substring(0, 4) == "+337" && ($("#telefono_input").val().length == 12)) {
                        //ok
                    } else {
                        $("#telefono_input").data("title", x_translate("Ingrese  un número de celular válido")).tooltip("show");
                        return false;
                    }
                }
            }


            $("#Main").spin("large");
            x_sendForm(
                    $('#f_contacto'),
                    true,
                    function (data) {
                        $("#Main").spin(false);
                        if (data.result) {
                            $('#hom-contacto-box').slideUp();
                            $('#hom-contacto-msg').show();
                            grecaptcha.reset();
                        } else {
                            x_alert(data.msg);
                        }

                    });
        };

        //mostrar modal de login
        $('#loginbtn,#loginbtn2, #loginbtn3').on('click', function (e) {

            e.preventDefault();
            $('.usrlogin').modal('toggle');
        });


    </script>
{/literal}