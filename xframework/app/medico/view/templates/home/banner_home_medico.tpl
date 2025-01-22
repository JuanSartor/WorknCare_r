<style>
    section.service-highlights{
        background: #ffffff !important;
    }
    #beneficios-medicos-carousel .row {
        display: flex;
        align-items: center;
    }
    .article-rsp>h4 {
        text-align: left; 
    }
    @media (max-width:992px) {
        #beneficios-medicos-carousel .row {
            flex-direction: column-reverse;
        }
        .article-rsp>h4 {
            text-align: center; 
        }
    }
    #beneficios-medicos-carousel.carousel>.carousel-inner>.item {
        min-height: 220px;
        height: min-content;
        overflow: hidden;
    }
    @media (max-width:600px) {

        #beneficios-medicos-carousel.carousel>.carousel-inner>.item {
            min-height: 410px;
        }
        section.service-highlights #beneficios-medicos-carousel article {
            min-height: 180px;
        }
        .medico-usuario-img-doctor {

            padding: 10px !important;
        }
    }

    section.service-highlights #beneficios-medicos-carousel article {
        padding: 0px !important;
    }
    section.service-highlights .tick {
        margin: 24px;
        width: auto;
    }

    section.service-highlights #beneficios-medicos-carousel h4 {
        font-size: 24px;
        margin: 20px;
    }
    section.service-highlights .carousel-control {
        position: absolute;
        justify-content: center;
        align-items: center;
        display: flex;
        color: #34495e;
        width:5%;
        z-index: 1;
    }

    section.service-highlights .carousel-control.left,section.service-highlights .carousel-control.right{
        background-image:none !important;
    }
    section.features .carousel-indicators.default-indicators li {
        margin: 0 5px;
    }

    #close-highlights{
        position: absolute;   
        z-index: 3000; 
        font-size: 24px; 
        font-weight: 600; 
        right: 15px; 
        margin-top: -10px;
        cursor: pointer;
        color: #34495e;
        opacity: 0.5;
    }
    #close-highlights:hover{
        opacity: 1;
    }
    .item-info-link{
        color: #f23243;
    }   
    .item-info-link i{
        margin-left: 10px;
        font-size: 12px;
    }


</style>
<section class="service-highlights medico-usuario-highlights features" style="display:none; position:relative">
    <a class="left carousel-control hidden-xs" href="#beneficios-medicos-carousel" role="button" data-slide="prev">
        <span class="fa fa-chevron-left" aria-hidden="true"></span>

    </a>
    <a class="right carousel-control hidden-xs" href="#beneficios-medicos-carousel" role="button" data-slide="next">
        <span class="fa fa-chevron-right" aria-hidden="true"></span>

    </a>
    <div class="container ">

        <a href="javascript:;" id="close-highlights" title='{"Ocultar"|x_translate}'><i class="fa fa-times"></i></a>
        <div id="beneficios-medicos-carousel" class="carousel slide" data-interval="15000" data-ride="carousel">

            <div class="carousel-inner" role="listbox">

                <div class="item active">
                    <div class="row">
                        <div class="col-md-3 doctor-smartphone-img">
                            <img class="medico-usuario-img-doctor" src="{$IMGS}medico/home-banner/doctorimg.jpg" >
                        </div>
                        <div class="col-md-9">
                            <article class="article-rsp">
                                <h4>{"Informatice su consultorio en pocos minutos"|x_translate}</h4>
                                <ul class="tick tick-responsive">
                                    <li>{"Consiga nuevos pacientes."|x_translate}</li>
                                    <li>{"Optimice su agenda de turnos."|x_translate}</li>
                                    <li>{"Ofrezca turnos online."|x_translate}</li>
                                    <li>{"Agenda de Turnos on line"|x_translate}</li>
                                </ul>
                            </article>
                        </div>
                    </div>
                </div>

                <div class="item ">
                    <div class="row">
                        <div class="col-md-3 doctor-smartphone-img">
                            <img class="medico-usuario-img-doctor" src="{$IMGS}medico/home-banner/configurar-agenda.png" >
                        </div>
                        <div class="col-md-9">
                            <article class="article-rsp">
                                <h4>{"¿Cómo configuro turnos en mi agenda?"|x_translate}</h4>
                                <ul class="tick tick-responsive">
                                    <li>{"Haz clic en tu foto en la esquina superior izquierda"|x_translate}</li>
                                    <li>{"Vaya a 'Consultorios, tarifas y servicios'"|x_translate}</li>
                                    <li>{"Haga clic en 'Seleccionar consultorio'"|x_translate}</li>
                                    <li>{"Haga clic en 'Agregar horario'"|x_translate}</li>
                                </ul>
                            </article>
                        </div>
                    </div>
                </div>

                <div class="item">
                    <div class="row">
                        <div class="col-md-3 doctor-smartphone-img">
                            <img src="{$IMGS}medico/home-banner/invitar-paciente.png"  class="medico-usuario-img-doctor" >
                        </div>
                        <div class="col-md-9">
                            <article class="article-rsp">
                                <h4>{"Cómo invitar a los pacientes?"|x_translate}</h4>
                                <ul class="tick tick-responsive">
                                    <li>{"Vaya a 'Mis pacientes' en el menú de la barra, luego 'Agregar'"|x_translate}</li>
                                    <li>{"Ingrese el número de teléfono  del paciente y luego haga clic en 'Enviar'"|x_translate}</li>
                                    <li>{"El paciente recibe un SMS con un enlace para abrir su cuenta."|x_translate}</li>
                                    <li>{"Ahora aparece como acceso directo para el paciente."|x_translate}</li>
                                </ul>

                            </article>
                        </div>

                    </div>
                </div>
                <div class="item">
                    <div class="row">
                        <div class="col-md-3 doctor-smartphone-img">
                            <img src="{$IMGS}medico/home-banner/sacar-turno-agenda.png"  class="medico-usuario-img-doctor">
                        </div>
                        <div class="col-md-9">
                            <article class="article-rsp">

                                <h4>{"Cómo hacer una cita de video consulta para un paciente?"|x_translate}</h4>
                                <ul class="tick tick-responsive">
                                    <li>{"Debe tener una Agenda, de lo contrario, vaya a información profesional para crearla."|x_translate}</li>
                                    <li>{"Hace clic en un intervalo de tiempo disponible en la Agenda"|x_translate}</li>
                                    <li>{"Usted busca a su paciente ingresando su nombre, de lo contrario lo invita"|x_translate}</li>
                                    <li>{"Envía la confirmación de la cita al paciente al que se le notifica"|x_translate}</li>
                                </ul>

                            </article>
                        </div>

                    </div>
                </div>
                <div class="item">
                    <div class="row">
                        <div class="col-md-3 doctor-smartphone-img">
                            <img src="{$IMGS}medico/home-banner/responder-ce.png"  class="medico-usuario-img-doctor">
                        </div>
                        <div class="col-md-9">
                            <article class="article-rsp">
                                <h4>{"Cómo responder a una solicitud de Consulta Express?"|x_translate}</h4>
                                <ul class="tick tick-responsive">
                                    <li>{"Haga clic en la notificación o alerta que indica una solicitud."|x_translate}</li>
                                    <li>{"Lo acepta y responde, o lo rechaza eligiendo un motivo"|x_translate}</li>
                                    <li>{"Puedes responder por mensaje de audio grabado"|x_translate}</li>
                                    <li>{"Escribe un informe simplificado, que el paciente recibe"|x_translate}</li>
                                </ul>
                            </article>
                        </div>

                    </div>
                </div>
                <div class="item">
                    <div class="row">
                        <div class="col-md-3 doctor-smartphone-img">
                            <img src="{$IMGS}medico/home-banner/responder-turno-vc.png"  class="medico-usuario-img-doctor">
                        </div>
                        <div class="col-md-9">
                            <article class="article-rsp">
                                <h4>{"Cómo responder a una solicitud de turno de Video Consulta?"|x_translate}</h4>
                                <ul class="tick tick-responsive">
                                    <li>{"Accede a la sección de notificaciones para ver la solicitud de cita."|x_translate}</li>
                                    <li>{"Lo acepta de inmediato o lo ve en su agenda"|x_translate}</li>
                                    <li>{"Su paciente recibe una notificación si la confirma"|x_translate}</li>
                                    <li>{"Puede cancelar la cita en cualquier momento, se notifica a su paciente"|x_translate}</li>
                                </ul>
                            </article>
                        </div>

                    </div>
                </div>
                <div class="item">
                    <div class="row">
                        <div class="col-md-3 doctor-smartphone-img">
                            <img src="{$IMGS}medico/home-banner/responder-vc.png"  class="medico-usuario-img-doctor">
                        </div>
                        <div class="col-md-9">
                            <article class="article-rsp">

                                <h4>{"Cómo responder a una solicitud de Video Consulta?"|x_translate}</h4>
                                <ul class="tick tick-responsive">
                                    <li>{"Hace clic en la notificación o alerta que indica una solicitud."|x_translate}</li>
                                    <li>{"Lo acepta de inmediato o dentro de un período determinado."|x_translate}</li>
                                    <li>{"Elija un intervalo de tiempo, por ejemplo: 15:00 - 16:00"|x_translate}</li>
                                    <li>{"Se le notificará cuando comience la video consulta, ¡usted ingresa a la sala!"|x_translate}</li>
                                </ul>
                            </article>
                        </div>

                    </div>
                </div>
                <div class="item">
                    <div class="row">
                        <div class="col-md-3 doctor-smartphone-img">
                            <img src="{$IMGS}medico/home-banner/videoconsulta.png"  class="medico-usuario-img-doctor" >
                        </div>
                        <div class="col-md-9">
                            <article class="article-rsp">
                                <h4>{"Cómo funciona la video consulta con el paciente?"|x_translate}</h4> 
                                <ul class="tick tick-responsive">
                                    <li>{"Usted ve la información del paciente a la derecha de la pantalla"|x_translate}</li>
                                    <li>{"Puede acceder a su registro de consultas y otra información"|x_translate}</li>
                                    <li>{"Tienes la iniciativa de colgar y finalizar la video consulta"|x_translate}</li>
                                    <li>{"En caso de problemas de conexión, vuelva a ingresar a la sala o vuelva a cargar la página"|x_translate}</li>
                                </ul>
                            </article>
                        </div>

                    </div>
                </div>
                <div class="item">
                    <div class="row">
                        <div class="col-md-3 doctor-smartphone-img">
                            <img src="{$IMGS}medico/home-banner/conclusion-medica.png"  class="medico-usuario-img-doctor">
                        </div>
                        <div class="col-md-9">
                            <article class="article-rsp">
                                <h4>{"Cómo escribir el informe de consulta de video?"|x_translate}</h4>
                                <ul class="tick tick-responsive">
                                    <li>{"Debe agregar la conclusión y las instrucciones de tratamiento."|x_translate}</li>
                                    <li>{"Una sección está reservada para recetas de medicamentos (si es necesario)"|x_translate}</li>
                                    <li>{"Una sección está reservada para cualquier tipo de documento en formato PDF"|x_translate}</li>
                                    <li>{"Puede agregar prescripción, hoja de tratamiento (si no hay teletransmisión)"|x_translate}</li>
                                </ul>
                            </article>
                        </div>

                    </div>
                </div>
                <div class="item">
                    <div class="row">
                        <div class="col-md-3 doctor-smartphone-img">
                            <img src="{$IMGS}medico/home-banner/preferencias-menu.png"  class="medico-usuario-img-doctor" >
                        </div>
                        <div class="col-md-9">
                            <article class="article-rsp">

                                <h4>{"Cómo personalizar tu cuenta?"|x_translate}</h4> 
                                <ul class="tick tick-responsive">
                                    <li>{"Vaya a 'Preferencias de uso' en la barra de menú"|x_translate}</li>
                                    <li>{"Puedes cambiar tus datos de inicio de sesión"|x_translate}</li>
                                    <li>{"Puedes definir con quién estás llamando"|x_translate}</li>
                                    <li>{"Puedes suscribirte a un abono profesional, puedes ver los tutoriales"|x_translate}</li>
                                </ul>
                            </article>
                        </div>

                    </div>
                </div>

            </div>
            <div class="okm-row text-center">
                <a class="item-info-link" href="{$url}panel-medico/consejos.html">{"Más Info"|x_translate}<span><i class="fa fa-chevron-right"></i></span></a>
            </div>
            <ol class="carousel-indicators default-indicators">
                <li data-target="#beneficios-medicos-carousel" data-slide-to="0" class="active"></li>
                <li data-target="#beneficios-medicos-carousel" data-slide-to="1"></li>
                <li data-target="#beneficios-medicos-carousel" data-slide-to="2"></li>
                <li data-target="#beneficios-medicos-carousel" data-slide-to="3"></li>
                <li data-target="#beneficios-medicos-carousel" data-slide-to="4"></li>
                <li data-target="#beneficios-medicos-carousel" data-slide-to="5"></li>
                <li data-target="#beneficios-medicos-carousel" data-slide-to="6"></li>
                <li data-target="#beneficios-medicos-carousel" data-slide-to="7"></li>
                <li data-target="#beneficios-medicos-carousel" data-slide-to="8"></li>
                <li data-target="#beneficios-medicos-carousel" data-slide-to="9"></li>

            </ol>


        </div>

    </div>

</section>
{literal}
    <script>

        $(function () {
            if (localStorage.getItem("hide-medico-usuario-highlights") != 1) {
                $(".medico-usuario-highlights").show();
            }
            $("#close-highlights").click(function () {
                var idsuscripcion = $(this).data("idsuscripcion");
                //confirmar la accion
                jConfirm({
                    title: x_translate("Ocultar consejos"),
                    text: x_translate("Confirma que desea ocultar la sección? Podrá encontrar esta información en la Guia de utilización"),
                    confirm: function () {

                        $(".medico-usuario-highlights").slideUp();
                        localStorage.setItem("hide-medico-usuario-highlights", 1);
                    },
                    cancel: function () {

                    },
                    confirmButton: x_translate("Si"),
                    cancelButton: x_translate("No")
                });

            });

            $('#beneficios-medicos-carousel').carousel({
                interval: 15000

            });

            $("#beneficios-medicos-carousel").on("touchstart", function (event) {
                var xClick = event.originalEvent.touches[0].pageX;
                $(this).one("touchmove", function (event) {
                    var xMove = event.originalEvent.touches[0].pageX;
                    if (Math.floor(xClick - xMove) > 5) {
                        $(this).carousel('next');
                    } else if (Math.floor(xClick - xMove) < -5) {
                        $(this).carousel('prev');
                    }
                });
                $("#beneficios-medicos-carousel").on("touchend", function () {
                    $(this).off("touchmove");
                });
            });
        });
    </script>
{/literal}
