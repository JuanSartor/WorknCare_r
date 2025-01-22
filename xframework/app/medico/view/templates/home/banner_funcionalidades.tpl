<style>
    section.features {
        background-color: #f6f6f6;
        padding: 12px 0;
    }
    section.features h3 {
        margin-bottom: 30px;
    }
    @media(max-width:768px){
        #app-features .item img {
            max-width: 240px !important;
        }
        section.features .item p,section.features h4.slide-title {
            font-size: 18px !important;
            font-weight: 500 !important;
        }
        section.features h3 {
            font-size: 19px !important;
            font-weight: 500 !important;
        }
    }   
</style>
<section class="professional features">
    <div class="container">
        <h3 class="text-center">{"Funcionalidades que le encantarán"|x_translate}</h3>
        <div id="app-features" class="carousel slide" data-interval="15000" data-ride="carousel">
            <!-- Indicators -->
            <ol class="carousel-indicators icon-indicators">
                <li class="dp-express" data-target="#app-features" data-slide-to="0" class="active"></li>
                <li class="icon-doctorplus-video-call" data-target="#app-features" data-slide-to="1"></li>
                <li class="dp-stats" data-target="#app-features" data-slide-to="2"></li>
                <li class="dp-alarm" data-target="#app-features" data-slide-to="3"></li>
                <li class="dp-info" data-target="#app-features" data-slide-to="4"></li>
            </ol>

            <!-- Wrapper for slides -->
            <div class="carousel-inner" role="listbox">
                <div class="item active">
                    <div class="row">
                        <div class="col-md-3 col-md-offset-2 col-xs-12">
                            <img class="img-responsive" src="{$IMGS}medico/new-home-medico-1.jpg" alt='{"Consulta Express"|x_translate}'>
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
                            <img class="img-responsive" src="{$IMGS}medico/new-home-medico-3.jpg" alt='{"Videoconsulta"|x_translate}'>
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
                            <img class="img-responsive" src="{$IMGS}graphic-stats.svg" alt='{"Estadísticas de sus Consultas"|x_translate}'>
                        </div>
                        <div class="col-md-6 col-xs-12">
                            <div class="content-wrapper">
                                <h4 class="slide-title">{"Estadísticas de sus Consultas"|x_translate}</h4>
                                <p>
                                    {"Sepa qué prepagas son las más utilizadas. Reportes de sus turnos, estadísticas de ausentismo, qué pacientes han faltado a su consulta, etc."|x_translate}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="item">
                    <div class="row">
                        <div class="col-md-3 col-md-offset-2 col-xs-12">
                            <img class="img-responsive" src="{$IMGS}graphic-envelope.svg" alt='{"Recordatorio de turnos"|x_translate}'>
                        </div>
                        <div class="col-md-6 col-xs-12">
                            <div class="content-wrapper">
                                <h4 class="slide-title">{"Recordatorio de turnos"|x_translate}</h4>
                                <p>
                                    {"Reduzca el ausentismo de sus pacientes gracias a los recordatorios de los turnos médicos que se envían automáticamente días previos a la cita."|x_translate}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="item">
                    <div class="row">
                        <div class="col-md-3 col-md-offset-2 col-xs-12">
                            <img class="img-responsive" src="{$IMGS}graphic-computer.svg" alt='{"Consulta Express"|x_translate}'>
                        </div>
                        <div class="col-md-6 col-xs-12">
                            <div class="content-wrapper">
                                <h4 class="slide-title">{"La Info de Salud de sus Pacientes"|x_translate}</h4>
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

{literal}
    <script>
        $(function () {
            $('#app-features').carousel({
                interval: 15000
            });
            $("#app-features").on("touchstart", function (event) {
                var xClick = event.originalEvent.touches[0].pageX;
                $(this).one("touchmove", function (event) {
                    var xMove = event.originalEvent.touches[0].pageX;
                    if (Math.floor(xClick - xMove) > 5) {
                        $(this).carousel('next');
                    } else if (Math.floor(xClick - xMove) < -5) {
                        $(this).carousel('prev');
                    }
                });
                $("#app-features").on("touchend", function () {
                    $(this).off("touchmove");
                });
            });
        });
    </script>
{/literal}
