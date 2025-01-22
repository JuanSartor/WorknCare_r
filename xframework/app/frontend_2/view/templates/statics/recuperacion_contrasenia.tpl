{if $paciente}
    {include file="paciente/menu.tpl"}
{/if}
{if $medico}
    {include file="medico/menu.tpl"}
{/if}

{include file="home/login.tpl"}
<!-- Cabecera común -->
<div class="plogin-header">
    <h1>{"Su cuenta como"|x_translate}</h1>
    <h2>{if $paciente}{"Paciente"|x_translate}{elseif $medico}{"Profesional de la salud"|x_translate}{/if}</h2>
    <h3>{"Restablecer contraseña"|x_translate}</h3>	
</div>


<!-- Formulario de cambio de contraseña -->
<section class="plogin-registro">
    <div id="registroAccordon" class="mapc-registro-box pul-nuevo-paciente-accordion">
        <div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true">
            <div class="panel panel-default">

                <div id="collapseOne" class="panel-collapse collapse in">
                    <div class="panel-body">
                        {if $resultado}
                            <form name="usr-registro-cuenta"  id="frmRegistro" role="form" action="{$url}{$controller}.php?action=1&modulo=login&submodulo=recuperacion_contrasenia" method="post" onsubmit="return false;">
                                <input type="hidden" name="hash" value="{$smarty.request.hash}" />
                                <input type="hidden" name="password" id="password" value="" />
                            </form>
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
                                    <button class="mapc-form-submit pul-np-form-submit" type="submit" id="accordion-pul-trg">{"Cambiar contraseña"|x_translate}</button>
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
                        {else}
                            <p class="text-center">{"La sección a la que está intentando acceder no es válida o ha caducado."|x_translate}</p>
                        {/if}
                    </div>
                </div>
            </div>

        </div>

    </div>

    <div class="plogin-mensaje-registro" id="mensajeRegistro">
        <h3 class="medico">{"¡Gracias por registrarse en DoctorPlus!"|x_translate}</h3>
        <h4>{"Su cuenta está pendiente de validación."|x_translate}</h4>
        <p class="plogin-envio-correo">
            {"Los datos profesionales ingresados serán chequeados por DoctorPlus."|x_translate}<br><br> 
            {"Será notificado cuando su cuenta como profesional haya sido validada."|x_translate}
        </p>

        <p>
            {"Recuerde poner a resguardo su información personal de ingreso al sistema  (usuario y contraseña), la necesitará para administrar su cuenta."|x_translate}
            {"Existen aplicaciones para smartphones y tablets que sirven para almacenar y cuidar todas las claves de modo seguro."|x_translate}
        </p>

        <div class="plogin-mensaje-registro-actions">
            <a href="#" class="btn-default">{"volver"|x_translate}</a>
        </div>

    </div>

</section>

{if $resultado}
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
                if (data.result) {
                    x_alert(x_translate("Su contraseña ha sido modificada con éxito."));
                    $("#loginbtn").click();

                } else {
                    x_alert(data.msg);
                }


            }


        });
    </script>
{/if}


<!-- Sección propia de Profesional -->
{if $medico}
    <section class="mapc-solucion-integral">
        <div class="okm-container">
            <h4>{"Una solución integral para las consultas fuera del consultorio"|x_translate}</h4>
            <p>{"DoctorPlus le ofrece la portabilidad y accesibilidad al Perfil de Salud de sus pacientes y la posibilidad de realizar  Consultas Médicas pagas a distancia en un solo espacio de trabajo."|x_translate}</p>

            <div class="okm-row">
                <div class="col-x3">
                    <h5>{"Consulta Express y Video Consulta"|x_translate}</h5>
                    <p class="mapc-solucion-integral-txt">
                        {"Capitalice las consultas que recibe fuera de su consultorio y atienda a sus pacientes a distancia pudiendo consultar su historial de visitas, prescripciones, tratamientos y los registros médicos de los profesionales frecuentes de su paciente."|x_translate}
                    </p>
                </div>
                <div class="col-x3">
                    <h5>{"La Salud de sus pacientes a su alcance en todo momento"|x_translate}</h5>
                    <p class="mapc-solucion-integral-txt">
                        {"La información de salud de sus pacientes en un solo lugar y siempre a su alcance esté donde esté. Para poder acompañar y tener seguimiento de los tratamientos indicados."|x_translate}
                    </p>
                </div>
                <div class="col-x3">
                    <h5>{"Además si desea administre también su Agenda de Turnos"|x_translate}</h5>
                    <p class="mapc-solucion-integral-txt">
                        {"¡Ofrezca sus turnos online las 24 hs todos los días! Reduzca el ausentismo con recordatorios automáticos a sus pacientes"|x_translate}
                    </p>
                </div>
            </div>
        </div>
    </section>	

    <section class="professional features">
        <div class="container">
            <div id="app-features" class="carousel slide" data-ride="carousel">
                <!-- Indicators -->
                <ol class="carousel-indicators icon-indicators">
                    <li class="medico-abono-icon-slide active" data-target="#app-features" data-slide-to="0" class="active"><i class="icon-doctorplus-chat"></i></li>
                    <li class="medico-abono-icon-slide" data-target="#app-features" data-slide-to="1"><i class="icon-doctorplus-pacientes"></i></li>
                    <li class="medico-abono-icon-slide" data-target="#app-features" data-slide-to="2"><i class="icon-doctorplus-calendar"></i></li>
                    <li class="medico-abono-icon-slide" data-target="#app-features" data-slide-to="3"><i class="icon-doctorplus-video-call"></i></li>
                    <li class="medico-abono-icon-slide" data-target="#app-features" data-slide-to="4"><i class="icon-doctorplus-pharmaceutics"></i></li>
                </ol>

                <!-- Wrapper for slides -->
                <div class="carousel-inner" role="listbox">
                    <div class="item active">
                        <div class="row">
                            <div class="col-sm-6  col-xs-12">
                                <img class="img-responsive" src="{$IMGS}medico/abono/slide-1.png" title='{"Consulta Express"|x_translate}'>
                            </div>
                            <div class="col-sm-6 col-xs-12">
                                <div class="content-wrapper">
                                    <h4 class="slide-title">{"Consulta Express"|x_translate}</h4>
                                    <p>
                                        {"La innovadora herramienta de consulta a distancia que le permitirá capitalizar sus consejos y consultas médicas fuera de su consultorio"|x_translate}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="row">
                            <div class="col-sm-6 col-xs-12">
                                <img class="img-responsive" src="{$IMGS}medico/abono/slide-2.png" title='{"Gestión de pacientes"|x_translate}'>
                            </div>
                            <div class="col-sm-6 col-xs-12">
                                <div class="content-wrapper">
                                    <h4 class="slide-title">{"Gestión de pacientes"|x_translate}</h4>
                                    <p>
                                        {"Interactúe con sus pacientes sin necesidad de llamadas telefónicas:"|x_translate}
                                    </p>
                                    <p>
                                        {"Notificaciones por renovación de recetas."|x_translate}  
                                        {"Recordatorios de próxima consulta, controles y chequeos"|x_translate}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="row">
                            <div class="col-sm-6 col-xs-12">
                                <img class="img-responsive" src="{$IMGS}medico/abono/slide-3.png" title='{"Administre su Agenda de Turnos"|x_translate}'>
                            </div>
                            <div class="col-sm-6 col-xs-12">
                                <div class="content-wrapper">
                                    <h4 class="slide-title">{"Administre su Agenda de Turnos"|x_translate}</h4>
                                    <p>
                                        {"¡Ofrezca sus turnos online las 24 hs todos los días!"|x_translate}
                                        {"Reduzca el ausentismo con recordatorios automáticos a sus pacientes"|x_translate}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="row">
                            <div class="col-sm-6 col-xs-12">
                                <img class="img-responsive" src="{$IMGS}medico/abono/slide-4.png" title='{"Video Consulta"|x_translate}'>
                            </div>
                            <div class="col-sm-6 col-xs-12">
                                <div class="content-wrapper">
                                    <h4 class="slide-title">{"Video Consulta"|x_translate}</h4>
                                    <p>
                                        {"Capitalice las consultas que recibe fuera de su consultorio y atienda a sus pacientes a distancia pudiendo consultar su historial de visitas, prescripciones, tratamientos y más!"|x_translate}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="row">
                            <div class="col-sm-6 col-xs-12">
                                <img class="img-responsive" src="{$IMGS}medico/abono/slide-5.png" title='{"El Perfil de Salud de sus Pacientes"|x_translate}'>
                            </div>
                            <div class="col-sm-6 col-xs-12">
                                <div class="content-wrapper">
                                    <h4 class="slide-title">{"El Perfil de Salud de sus Pacientes"|x_translate}</h4>
                                    <p>
                                        {"Acceda fácilmente al Perfil de Salud sus pacientes tanto desde su Consultorio como desde cualquier otro lugar, utilizando una computadora o dispositivo móvil (Consultorio Online)"|x_translate}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <ol class="carousel-indicators default-indicators">
                    <li data-target="#app-features" data-slide-to="0" class="active"></li>
                    <li data-target="#app-features" data-slide-to="1"></li>
                    <li data-target="#app-features" data-slide-to="2"></li>
                    <li data-target="#app-features" data-slide-to="3"></li>
                    <li data-target="#app-features" data-slide-to="4"></li>
                </ol>
                <!-- Controls -->
            </div>
        </div>
    </section>
{/if}


<!-- Sección propia de paciente -->
{if $paciente}
    <section class="consulta-express-slider-holder plogin-slider">

        <div id="consulta-express-slider" class="carousel slide" data-ride="carousel">

            <!-- Wrapper for slides -->
            <div class="carousel-inner" role="listbox">


                <div class="item active">
                    <div class="item-3">
                        <div class="item-inner">
                            <div class="item-3-top">
                                <span class="consulta-express-arrow"></span>
                                <h3>{"Consulta Express"|x_translate}</h3>
                            </div>
                            <div class="item-3-body item-3-back-1">

                                <div class="item-2-icon-holder">
                                    <div class="item-2-icon-shadow"></div>
                                    <div class="item-3-icon-icon">
                                        <i class="icon-doctorplus-video-call"></i>
                                    </div>
                                </div>

                                <div class="item-2-content-holder">
                                    <div class="item-2-content">
                                        <h4>{"¿Todavía perdés tiempo en un consultorio por una consulta breve?"|x_translate}</h4>
                                        <p>{"Consultá a tus médicos de confianza sin moverte de tu casao el trabajo"|x_translate}</p>
                                        <ul>
                                            <li>{"Más simple."|x_translate}</li>
                                            <li>{"Más cómodo."|x_translate} </li>
                                            <li>{"Más práctico!"|x_translate}</li>
                                        </ul>
                                    </div>
                                    <div class="item-shadow"></div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>



                <div class="item">
                    <div class="item-2 back-2">
                        <div class="item-inner item-2-fig-holder">
                            <div class="item-2-stripes">
                                <div class="item-2-icon-holder">
                                    <div class="item-2-icon-shadow"></div>
                                    <div class="item-2-icon-icon">
                                        <i class="icon-doctorplus-organigrama"></i>
                                    </div>
                                </div>
                                <div class="item-2-content-holder">
                                    <div class="item-2-content">
                                        <h4>{"¡Conectándonos fácilmente cuidamos mejor su salud!"|x_translate}</h4>
                                        <p>
                                            {"Comience a disfrutar de los beneficios de DoctorPlus. La nueva red de e-Salud que conecta a médicos y pacientes"|x_translate}
                                        </p>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="item">
                    <div class="item-3">
                        <div class="item-inner">
                            <div class="item-3-top">
                                <span class="consulta-express-arrow"></span>
                                <h3>{"Video Consulta"|x_translate}</h3>
                            </div>
                            <div class="item-3-body item-3-back-3">

                                <div class="item-2-icon-holder">
                                    <div class="item-2-icon-shadow"></div>
                                    <div class="item-3-icon-icon">
                                        <i class="icon-doctorplus-video-call"></i>
                                    </div>
                                </div>

                                <div class="item-2-content-holder">
                                    <div class="item-2-content">
                                        <h4>{"¿Estás de viaje o no podés trasladarte y necesitas hacerle una consulta a tu médico de confianza?"|x_translate}</h4>
                                        <p>
                                            {"¡DoctorPlus lo hace posible! Tu médico te atiende en vivo y en directo a traves de una Video Consulta."|x_translate}
                                        </p>
                                        <div class="item-3-content-link-holder">
                                            <a class="item-3-content-link" href="#">Más Info <span></span></a>
                                        </div>
                                    </div>
                                    <div class="item-shadow"></div>
                                </div>

                            </div>
                        </div>
                    </div>
                </div>


                <div class="item">
                    <div class="item-4">
                        <div class="item-inner item-4-img">

                            <div class="item-4-frame-holder">

                                <div class="item-2-icon-holder">
                                    <div class="item-2-icon-shadow"></div>
                                    <div class="item-3-icon-icon">
                                        <i class="icon-doctorplus-video-call"></i>
                                    </div>
                                </div>

                                <div class="item-4-content-holder">
                                    <div class="item-4-content">
                                        <h4>
                                            {"Profesionales en la red"|x_translate}
                                        </h4>
                                        <p>
                                            {"Su consulta atendida en menor tiempo por nuestra red de Profesionales y especialistas."|x_translate}
                                        </p>
                                        <p>
                                            {"¡Conectándonos fácilmente cuidamos mejor su salud!"|x_translate}
                                        </p>
                                        <div class="item-3-content-link-holder">
                                            <a class="item-3-content-link" href="#">{"Más Info"|x_translate} <span></span></a>
                                        </div>
                                    </div>
                                    <div class="item-shadow"></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>



            </div>
            <ol class="carousel-indicators default-indicators consulta-express-indicators">
                <li data-target="#consulta-express-slider" data-slide-to="0" class="active"></li>
                <li data-target="#consulta-express-slider" data-slide-to="1"></li>
                <li data-target="#consulta-express-slider" data-slide-to="2"> </li>
                <li data-target="#consulta-express-slider" data-slide-to="3"></li>
            </ol>
            <!-- Controls -->
        </div>
        <div class="consulta-express-slider-foot">
            <span>{"Si ud. desea realizar una Consulta Express o Video Consulta recuerde que el Perfil de Salud del paciente debe estar completo"|x_translate}</span>
        </div>



    </section>
{/if}