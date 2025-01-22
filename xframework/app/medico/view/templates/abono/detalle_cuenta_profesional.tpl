
<div class="main-content home">
    <section class="professional account-type container text-center">
        <h1>{"Cuenta Profesional"|x_translate}</h1>
        <h2>{"¡Todas las funcionalidades sin descuentos por comisión!"|x_translate}</h2>
        <p class="medico-abono-subtitle">
            {"Ideal para profesionales con alta demanda y requerimiento de sus pacientes fuera del consultorio"|x_translate}
        </p>
        <div class="row highlights medico-abono-highlights">
            <div class="col-md-4 col-sm-4">
                <figure>
                    <img src="{$IMGS}doctor_phone.jpg" alt="" class="img-responsive" />
                </figure>
                <div class="highlight-box text-center">
                    <div class="price">
                        <span>&euro;{$MONTO_CUOTA}</span>
                        <span>{"finales/MES"|x_translate}</span>
                    </div>
                    {if $medico.planProfesional == "0"}
                    <a href="{$url}panel-medico/abono-proceso-compra/" role="button" title='{"Adquirir cuenta Profesional"|x_translate}'>{"Adquirir"|x_translate}</a>
                    {else}
                    <a id="btnEliminarSuscripcion" data-idsuscripcion="{$medico.suscripcion_premium_idsuscripcionactiva}" role="button" title='se désabonner'>Désabonner</a>
                    {/if}
                </div>
                {*<p class="disclaimer uppercase"><small>{"Pesos Argentinos"|x_translate}</small></p>*}
            </div>
            <div class="col-md-7 col-md-offset-1 col-sm-7 col-sm-offset-1 plan-highlights">

                <button class="toggle-features visible-xs">{"Ver Características"|x_translate}</button>
                <div class="row special-features medico-abono-highlights-list">
                    <ul>
                        <li><i class="icon-doctorplus-calendar"></i> <span>{"Agenda de Turnos on line"|x_translate}</span></li>
                        <li><i class="icon-doctorplus-despertador"></i> <span>{"Recordatorios por mail y SMS para reducir el ausentismo"|x_translate}</span></li>
                        <li><i class="icon-doctorplus-pharmaceutics"></i> <span>{"Acceso a la Info de Salud de sus pacientes desde cualquier dispositivo"|x_translate}</span></li>
                        <li><i class="icon-doctorplus-pharmaceutics-sheet"></i> <span>{"Registro de sus consultas médicas a distancia"|x_translate}</span></li>
                        <li><i class="icon-doctorplus-chat"></i> <span>{"Consulta Express"|x_translate}</span></li>
                        <li><i class="icon-doctorplus-video-call"></i> <span>{"Video Consulta"|x_translate}</span></li>
                        <li><i class="icon-doctorplus-pacientes"></i> <span>{"Gestión de pacientes"|x_translate}</span></li>
                        <li><i class="icon-doctorplus-people-add"></i> <span>{"Contacto con los médicos frecuentes del paciente"|x_translate}</span></li>
                        <li><i class="icon-doctorplus-usr-like"></i> <span>{"50 Pacientes con servicio de CE bonificados"|x_translate}</span></li>
                        <li><i class="icon-doctorplus-sheet"></i> <span>{"Envío de consejos médicos"|x_translate}</span></li>
                        <li><i class="icon-doctorplus-gear-round"></i> <span>{"Soporte Técnico"|x_translate}</span></li>
                    </ul>
                </div>
            </div>
        </div>
        <div class="medico-abono-highlights-list-disclaimer">
           
        </div>

    </section>
    <div class="medico-abono-highlights-contratacion">
        <p>{"Inicialmente la contratación mínima es de 6 (seis) meses. PRECIOS EXPRESADOS EN PESOS ARGENTINOS IVA INCLUÍDO"|x_translate}</p>
    </div>
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
                                    <p>{"La innovadora herramienta de consulta a distancia que le permitirá capitalizar sus consejos y consultas médicas fuera de su consultorio"|x_translate}
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
                                        {"Notificaciones por renovación de recetas. Solicitud de certificados y aptos médicos. Recordatorios de próxima consulta, controles y chequeos"|x_translate}
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
                                    <p>{"¡Ofrezca sus turnos online las 24 hs todos los días! Reduzca el ausentismo con recordatorios automáticos a sus pacientes"|x_translate}
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
                                    <p>{"Capitalice las consultas que recibe fuera de su consultorio y atienda a sus pacientes a distancia pudiendo consultar su historial de visitas, prescripciones, tratamientos y más!"|x_translate}
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
                                    <p>{"Acceda fácilmente al Perfil de Salud sus pacientes tanto desde su Consultorio como desde cualquier otro lugar, utilizando una computadora o dispositivo móvil (Consultorio Online)"|x_translate}
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
    <section class="more-features">
        <div class="container">
            <div class="row">
                <h3 class="section-title">{"¡Reduzca el ausentismo!"|x_translate}</h3>
                <img class="img-responsive centered" src="{$IMGS}graphic-sms.png" title='{"Alertas SMS"|x_translate}'>
                <div class="col-md-6 col-md-offset-6 benefits">
                    <div class="dp-sms"></div>
                    <h3>{"Envíe confirmaciones y recordatorios de turnos"|x_translate} <br>{"por SMS  a sus pacientes"|x_translate}</h3>
                    <p>{"Una de las principales causas de ausentismo de pacientes es el olvido de su turno médico."|x_translate}<br />
                        {"Mediante el envío automático de recordatorios de turnos por SMS, los pacientes recibirán una notificación de DoctorPlus en su celular horas antes de su turno disminuyendo asi la tasa de ausentismo en su consultorio."|x_translate}
                    </p>
                </div>
            </div>
        </div>
    </section>
    {if $medico.planProfesional == "0"}
    <section class="order">
        <div class="container text-center">
            <h5>{"Todo incluido, por un PRECIO inmejorable"|x_translate}</h5>

            <div class="account-type pro">
                <div>
                    <span>{"Cuenta Profesional"|x_translate}</span>
                    <span class="price">&euro;{$MONTO_CUOTA}<span>{"finales/MES"|x_translate}</span></span>
                </div>
            </div>

            <p class="disclaimer text-center uppercase">{"PRECIOS EXPRESADOS EN PESOS ARGENTINOS"|x_translate}</p>
            <a href="{$url}panel-medico/abono-proceso-compra/" class="uppercase next small" role="button" title='{"Adquirir cuenta Profesional"|x_translate}'>{"ADQUIRIR"|x_translate}</a>
        </div>
    </section>
    {/if}
</div>

{literal}
<script>
    $("#btnEliminarSuscripcion").click(function(){

        var idsuscripcion = $(this).data("idsuscripcion");
        //confirmar la accion
        jConfirm({
            title: x_translate("Cancelar Suscripción Premium"),
            text: x_translate("Confirma que desea cancelar la suscripción premium?"),
            confirm: function () {
                
                $("body").spin("large");
                x_doAjaxCall(
                    'POST',
                    BASE_PATH + "cancelar_suscripcion.do",
                    "id="+idsuscripcion,
                    function (data) {
                        x_alert(data.msg);
                        $("body").spin(false);
                        if (data.result) {     
                             window.location.reload();
                            //$("#div_invitaciones_pacientes").spin("large");
                            //x_loadModule('pacientes', 'invitaciones_pacientes_list', '', 'div_invitaciones_pacientes');
                        }
                    }
                );
            },
            cancel: function () {
                
            },
            confirmButton: x_translate("Si"),
            cancelButton: x_translate("No")
        });
    })
</script>
{/literal}