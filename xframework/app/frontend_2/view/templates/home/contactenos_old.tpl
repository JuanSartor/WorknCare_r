<style>
    .grecaptcha-badge{
        margin: auto;
    }
    .hom-contacto button[type=submit] {
        border: 0;
        background-color: #02b8c1;
        padding: 8px 62px;
        margin: 0;
        margin-top:15px;
    }
</style>
<section class="okm-container hom-contacto">
    <h4 id="hom-contacto">{"Contáctenos"|x_translate}</h4>
    <div class="hom-servicios-bottom-action-box">
        <i class="icon-doctorplus-arrow-down"></i>
    </div>
    <div class="hom-contacto-box">
        <div id="hom-contacto-box" class="hom-contacto-box">
            <form id="f_contacto" name="hom-contacto" action="{$url}enviar_mail_contacto.do" method="POST" onsubmit="return false;">
                <div class="hom-form-row">
                    <div class="hom-form-col-x2">
                        <label>{"Nombre"|x_translate}<span>*</span></label>
                        <input type="text" name="nombre" required="required" >


                    </div>

                    <div class="hom-form-col-x2">
                        <label>{"Apellido"|x_translate}<span>*</span></label>
                        <input type="text" name="apellido" required="required" >

                    </div>

                </div>

                <div class="hom-form-row">
                    <div class="hom-form-col-x2">
                        <label>{"Email"|x_translate}<span>*</span></label>
                        <input id="email_contacto" type="text" name="email" required="required" >

                    </div>

                    <div class="hom-form-col-x2">
                        <label>{"Teléfono"|x_translate}</label>
                        <input type="tel" id="telefono_contacto" name="telefono" >

                    </div>

                </div>

                <div class="hom-form-row">
                    <div class="hom-form-col-x1">
                        <label>{"Mensaje"|x_translate}</label>
                        <textarea name="mensaje" required="required" ></textarea>
                    </div>
                </div>
                <div class="hom-form-row hom-form-action">

                    <button type="submit"  id="btnEnviarMailContacto" class="btn-default g-recaptcha"  data-callback='enviarMailContacto' data-badge="inline" data-action='submit' data-sitekey="{$RECAPTCHA_PUBLIC}" />{"Enviar"|x_translate}<button>
                </div>
                <label for="cc-num" class="hidden">exclude form</label>
                <input name="cc-num" class="hidden" required="" value="HubspotCollectedFormsWorkaround" id="cc-num">

            </form>
        </div>
        <div id="hom-contacto-msg" class="hom-contacto-msg">
            <p>
                {"Su consulta ha sido enviada."|x_translate}<br>
                {"Nos pondremos en contacto con usted a la brevedad"|x_translate}
            </p>
            <p>
                {"El equipo de DoctorPlus"|x_translate}
            </p>
        </div>
    </div>
</section>
<script src="https://www.google.com/recaptcha/api.js?hl=fr" async defer>

</script>

{literal}
    <script>
        $(function () {
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
        }
    </script>
{/literal}