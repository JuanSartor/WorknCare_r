{include file="programa_salud_registro/menu.tpl"}
{include file="programa_salud_registro/login.tpl"}
<!-- Cabecera común -->
<div class="plogin-header">
    <div class="text-center">
        <img  src="{$IMGS}logo_pass_bienetre.png" style="width:200px"/>
    </div>
    <h1 class="text-center">{"El Pase de Salud, ¡no cuesta nada probarlo!"|x_translate}</h1>
    <h2 class="text-center">{"Afiliación gratuita"|x_translate}</h2>
</div>


<!-- Formulario de cambio de contraseña -->
<section class="plogin-registro">
    <div id="registroAccordon" class="mapc-registro-box pul-nuevo-paciente-accordion">
        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
            <div class="panel panel-default">

                <div id="collapseOne" class="panel-collapse collapse in">
                    <div class="panel-body">
                        <form name="usr-registro-cuenta"  id="frmRegistro" role="form" action="{$url}{$controller}.php?action=1&modulo=login&submodulo=setear_contrasenia_usuario_empresa" method="post" onsubmit="return false;">
                            <input type="hidden" name="hash" value="{$smarty.request.hash}" />
                            <input type="hidden" name="password" id="password" value="" />
                        </form>
                        <div class="okm-row">
                            <p class="text-center">
                                {"Bienvenido"|x_translate}&nbsp;{$usuario_secundario.nombre} {$usuario_secundario.apellido}!
                            </p>
                        </div>
                        <div class="okm-row">
                            <div class="pul-col-x2">
                                <div class="mapc-registro-form-row">
                                    <label class="mapc-label">{"Nueva contraseña"|x_translate}</label>
                                    <div class="mapc-input-line">
                                        <input type="password" class="pul-np-dis input_password_strength"  placeholder='{"Contraseña de 8 caracteres"|x_translate}' id="password_aut" />
                                        <i class="icon-doctorplus-lock"></i>
                                    </div>
                                </div>
                            </div>
                            <div class="pul-col-x2">
                                <div class="mapc-registro-form-row">
                                    <label class="mapc-label">{"Repita la contraseña"|x_translate}</label>
                                    <div class="mapc-input-line">
                                        <input type="password" class="pul-np-dis"  placeholder='{"Contraseña de 8 caracteres"|x_translate}' id="repassword_aut" />
                                        <i class="icon-doctorplus-lock"></i>
                                    </div>
                                </div>
                            </div>
                        </div>
                        <div class="okm-row">
                            <div class="mapc-registro-form-row">
                                <button class="mapc-form-submit pul-np-form-submit" type="submit" id="accordion-pul-trg">{"Confirmar mi cuenta"|x_translate}</button>
                            </div>
                        </div>
                        <div class="okm-row">
                            <div class="mapc-politicas-box" id="politicas">

                                <div class="mapc-politicas-holder">

                                    <div class="mapc-politicas">
                                        <p>
                                            {"Recuerde poner a resguardo su información personal de ingreso al sistema (usuario y clave), la nececitará para administrar su cuenta. Existen aplicaciones que sirven para almacenar y cuidar las claves de modo seguro."|x_translate}
                                        </p>
                                    </div>
                                </div>
                                <div class="mapc-politicas-holder">
                                    <figure>
                                        <i class="icon-doctorplus-lock"></i>
                                    </figure>
                                    <div class="mapc-politicas">
                                        <p>
                                            {"La  información de registro de su cuenta de usuario se almacena  encriptada en nuestra base de datos."|x_translate}
                                        </p>
                                        <p>{"Consulte nuestra política de privacidad y protección de datos"|x_translate}</p>
                                    </div>
                                </div>
                            </div>
                        </div>

                    </div>
                </div>
            </div>

        </div>

    </div>

</section>


<script language="javascript" >

    $(document).ready(function () {
        $('#password_aut,#repassword_aut').strength({
            strengthClass: 'input_password_strength',
            strengthMeterClass: 'strength_meter',
            strengthButtonClass: 'button_strength',
            strengthButtonText: 'Show Password',
            strengthButtonTextToggle: 'Hide Password'
        });



        $(".button_strength").hide();

        $("#accordion-pul-trg").click(function () {
            $("#frmRegistro").submit();
        });
        $("#frmRegistro").validate({
            onfocusout: false,
            showErrors: function (errorMap, errorList) {

                // Clean up any tooltips for valid elements
                $.each(this.validElements(), function (index, el) {
                    var $el = $(el);
                    if ($el.is(':data(tooltip)')) {
                        $el.tooltip("destroy");
                    }
                });

                if (errorList.length === 0) {
                    return;
                }

                $element = $(errorList[0].element);

                $('html, body').animate({
                    scrollTop: $element.offset().top - (($("#topnavigation").is(":visible")) ? 150 : 0)
                }, 1000);

                if ($element.is(':data(tooltip)')) {
                    $element.tooltip("destroy") // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                            .data("title", $element.attr("placeholder"))
                            .tooltip(); // Create a new tooltip based on the error messsage we just set in the title
                } else {
                    $element // Destroy any pre-existing tooltip so we can repopulate with new tooltip content
                            .data("title", $element.attr("placeholder"))
                            .tooltip();
                }


            },
            submitHandler: function (form) {
                var password1 = $.trim($('#password_aut').val());
                var password2 = $.trim($('#repassword_aut').val());

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

                if (password1 === password2) {
                    var valor = Base64.encode(SHA1(password1));
                    $("#password").val(valor);
                    $('#repassword_aut').val("");
                    $('#password_aut').val("");
                } else {
                    x_alert(x_translate("Las contraseñas no son iguales"));
                    return;
                }
                $("body").spin("large");
                x_sendForm($('#frmRegistro'), true, alert_resultado);

                return false;
            }
        });



        function alert_resultado(data) {
            $("body").spin(false);
            x_alert(data.msg);
            if (data.result) {
                $("#loginbtn").click();
            }
        }

    });
</script>
