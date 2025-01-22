
<div class="main-content home">
    <section class="free account-type container text-center">
        <h1>{"Cuenta Gratuita"|x_translate} </h1>
        <h2>{"Sin demos ni períodos de prueba. Una cuenta gratuita para siempre"|x_translate}</h2>
        <div class="row highlights">
            <div class="col-sm-3">
                <figure>
                    <img src="{$IMGS}graphic-free-account.svg" alt="" class="img-responsive" />
                </figure>
                <div class="highlight-box text-center">
                    <div class="price">
                        <span>{"Gratis"|x_translate}</span>
                    </div>
                    {if $medico.planProfesional != 0}
                        <a href="javascript:;" role="button" id="cambiarCuentaGratuita" title='{"Cambiar de Cuenta Profesional a Cuenta Gratuita"|x_translate}' role="button">{"Adquirir"|x_translate}</a>
                    {/if}
                </div>
                <div class="box-shadow-image"></div>
            </div>
            <div class="col-sm-8 col-sm-offset-1 plan-highlights">
                <p>{"¡Comience a disfrutar de todas las funcionalidades ya!"|x_translate}</p>
                <button class="toggle-features visible-xs">{"Ver Características"|x_translate}</button>
                <div class="row special-features">
                    <div class="col-md-4">
                        <ul>
                            <li><span class="dp-agenda">{"Agenda de Turnos on line"|x_translate}</span></li>
                            <li><span class="dp-alarm">{"Recordatorios o cancelaciones de turnos por email"|x_translate}</span></li>
                            <li><span class="dp-sms">{"Recordatorios o cancelaciones de turnos por SMS"|x_translate}</span></li>
                            <li><span class="dp-info">{"Acceso a la Info de Salud de sus pacientes desde cualquier dispositivo"|x_translate}</span></li>
                        </ul>
                    </div>
                    <div class="col-md-4">
                        <ul>
                            <li><span class="dp-express">{"Consulta Express"|x_translate} (1)</span></li>
                            <li><span class="dp-video">{"Video Consulta"|x_translate} (1)</span></li>
                            <li><span class="dp-support">{"Soporte Técnico por chat y email"|x_translate}</span></li>
                            <li><span class="dp-stats">{"Registro de sus consultas médicas a distancia"|x_translate}</span></li>
                        </ul>
                    </div>
                    <small>(1) {$COMISION_VC}%&nbsp;{"de costo de uso por consulta. ¡OPTA POR LA SUSCRIPCIÓN DE 10 CONSULTAS POR MES!"|x_translate}</small>		
                </div>
            </div>

        </div>

    </section>

    <section class="professional features">
        <div class="container">
            <h3 class="text-center">{"Funcionalidades que le encantarán"|x_translate}</h3>
            <div id="app-features" class="carousel slide" data-interval="false">
                <!-- Indicators -->
                <ol class="carousel-indicators icon-indicators">
                    <li class="dp-express active" data-target="#app-features" data-slide-to="0"></li>
                    <li class="dp-video" data-target="#app-features" data-slide-to="1"></li>
                    <li class="dp-stats" data-target="#app-features" data-slide-to="2"></li>
                    <li class="dp-alarm" data-target="#app-features" data-slide-to="3"></li>
                    <li class="dp-info" data-target="#app-features" data-slide-to="4"></li>
                </ol>

                <!-- Wrapper for slides -->
                <div class="carousel-inner" role="listbox">
                    <div class="item active">
                        <div class="row">
                            <div class="col-md-3 col-md-offset-2 col-xs-12">
                                <img class="img-responsive" src="{$IMGS}doctor_smartphone.jpg" title='{"Consulta Express"|x_translate}'>
                            </div>
                            <div class="col-md-6 col-xs-12">
                                <div class="content-wrapper">
                                    <h4 class="slide-title">{"Consulta Express"|x_translate}</h4>
                                    <p>
                                        {"La innovadora herramienta de consulta a distancia que le permitirá capitalizar sus consejos y consultas médicas fuera de su consultorio."|x_translate}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="row">
                            <div class="col-md-3 col-md-offset-2 col-xs-12">
                                <img class="img-responsive" src="{$IMGS}doctor_smartphone.jpg" title='{"Consulta Express"|x_translate}'>
                            </div>
                            <div class="col-md-6 col-xs-12">
                                <div class="content-wrapper">
                                    <h4 class="slide-title">{"Videoconsulta"|x_translate}</h4>
                                    <p>
                                        {"Gane más libertad personal, ejerciendo su profesión desde el lugar de su elección."|x_translate}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="row">
                            <div class="col-md-3 col-md-offset-2 col-xs-12">
                                <img class="img-responsive" src="{$IMGS}graphic-stats.svg" title='{"Estadísticas de sus Consultas"|x_translate}'>
                            </div>
                            <div class="col-md-6 col-xs-12">
                                <div class="content-wrapper">
                                    <h4 class="slide-title">{"Estadísticas de sus Consultas"|x_translate}</h4>
                                    <p> {"Sepa qué prepagas son las más utilizadas."|x_translate} <br> {"Reportes de sus turnos, estadísticas de ausentismo, qué pacientes han faltado a su consulta, etc."|x_translate}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="row">
                            <div class="col-md-3 col-md-offset-2 col-xs-12">
                                <img class="img-responsive" src="{$IMGS}graphic-envelope.svg" title='{"Recordatorio de turnos"|x_translate}'>
                            </div>
                            <div class="col-md-6 col-xs-12">
                                <div class="content-wrapper">
                                    <h4 class="slide-title">{"Recordatorio de turnos"|x_translate}</h4>
                                    <p>{"Reduzca el ausentismo de sus pacientes gracias a los recordatorios de los turnos médicos que se envían automáticamente días previos a la cita."|x_translate}
                                    </p>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="item">
                        <div class="row">
                            <div class="col-md-3 col-md-offset-2 col-xs-12">
                                <img class="img-responsive" src="{$IMGS}graphic-computer.svg" title='{"Consulta Express"|x_translate}'>
                            </div>
                            <div class="col-md-6 col-xs-12">
                                <div class="content-wrapper">
                                    <h4 class="slide-title">{"El Perfil de Salud de sus Pacientes"|x_translate}</h4>
                                    <p>
                                        {"Acceda fácilmente a la Info de Salud sus Pacientes tanto desde su Consultorio como desde cualquier otro lugar, utilizando una computadora o dispositivo móvil (Consultorio Online)."|x_translate}
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
    {if $medico.planProfesional != 0}
        <section class="order free-account">
            <div class="container text-center">
                <h5>{"Sin demos ni períodos de prueba."|x_translate}<br />
                    {"¡Una cuenta gratuita para siempre!"|x_translate}</h5>

                <div class="account-type">
                    <div>
                        <span>{"Cuenta Gratuita"|x_translate}</span>
                    </div>
                </div>
                <a href="#" class="uppercase next small" role="button">{"Adquirir"|x_translate}</a>
            </div>
        </section>
    {/if}
</div>


{literal}
    <script>
        $("#cambiarCuentaGratuita, #cambiarCuentaGratuita2").click(function () {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'change_cuenta_gratuita.do',
                    "",
                    function (data) {
                        x_alert(data.msg);
                        if (data.result) {
                            window.location.href = BASE_PATH + "panel-medico/";
                        }
                    }
            );
        });
    </script>
{/literal}