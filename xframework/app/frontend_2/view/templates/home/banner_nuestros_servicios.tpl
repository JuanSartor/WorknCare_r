<section class="hin-soluciones" id="soluciones">
    <div class="okm-container hin-servicios">
        <h2 id="hom-quehacer">          
            {"¿Cómo usar DoctorPlus?"|x_translate}
        </h2>

        <div class="okm-row servicios-container">

            <div class="hin-servicios-mobile-col">

                <div class="hin-servicios-mobile-image-box anim-image-servicios">
                    <video playsinline preload autoplay muted loop>

                        <source src="{$url}xframework/app/themes/dp02/videos/nuestros_servicios_passbienetre_video.mp4" type="video/mp4">
                        <source src="{$url}xframework/app/themes/dp02/videos/nuestros_servicios_passbienetre_video.webm" type="video/webm">
                    </video>
                </div>
            </div>

            <div class="hin-servicios-col">
                <a href="javascript:;" class="servicios pcuh-pf-slide-control left"><i class="icon-doctorplus-left-arrow"></i></a>
                <div class="carousel-servicios">
                    <div class="hin-servicio-row">
                        <figure class="hin-servicio-icon red">
                            <i class="icon-doctorplus-video-cam"></i>		
                        </figure>
                        <div class="hin-servicio-title">
                            <h4>{"Video Consulta"|x_translate}</h4>
                            <div class="hin-servicio-content">
                                <p>
                                    {"Consulte a su médico de cabecera y hable con él como lo haría en el consultorio. En el 80% de los casos, esto debería ser suficiente para una opinión médica o una consulta de seguimiento"|x_translate}
                                </p>
                            </div>
                        </div>

                    </div>

                    <div class="hin-servicio-row">
                        <figure class="hin-servicio-icon green">
                            <i class="icon-doctorplus-video-call"></i>	
                        </figure>
                        <div class="hin-servicio-title">
                            <h4>{"Perfil de salud e historial de consultas"|x_translate}</h4>
                            <div class="hin-servicio-content">
                                <p>
                                    {"Centralice su información de salud y manténgala siempre a mano"|x_translate}
                                </p>
                            </div>
                        </div>

                    </div>

                    <div class="hin-servicio-row">
                        <figure class="hin-servicio-icon red">
                            <i class="icon-doctorplus-usr-group"></i>	
                        </figure>

                        <div class="hin-servicio-title">
                            <h4>{"Haga una cita, invite a su médico."|x_translate}</h4>
                            <div class="hin-servicio-content">
                                <p>
                                    {"Invita a tu médico y a los profesionales de la salud que conoces. De lo contrario, encuentre en unos pocos clics los profesionales disponibles"|x_translate}
                                </p>
                            </div>
                        </div>

                    </div>
                    <div class="hin-servicio-row">
                        <figure class="hin-servicio-icon green">
                            <i class="icon-doctorplus-chat"></i>					
                        </figure>
                        <div class="hin-servicio-title">
                            <h4>{"Aviso y consejos"|x_translate}</h4>
                            <div class="hin-servicio-content">
                                <p>
                                    {"Tu doctor también está ocupado. Más dinámico que un correo electrónico ... y mucho menos intrusivo que la mensajería instantánea"|x_translate}
                                </p>
                            </div>
                        </div>

                    </div>

                    <div class="hin-servicio-row">
                        <figure class="hin-servicio-icon red">
                            <i class="fa fa-mobile-phone"></i>						
                        </figure>
                        <div class="hin-servicio-title">
                            <h4>{"Notificaciones y controles"|x_translate}</h4>
                            <div class="hin-servicio-content">
                                <p>
                                    {"Tu libro de salud conectado. Reciba recordatorios de citas, cheques y alertas automáticas de vacunación"|x_translate}
                                </p>
                            </div>
                        </div>

                    </div>

                    <div class="hin-servicio-row">
                        <figure class="hin-servicio-icon green">
                            <i class="icon-doctorplus-pharmaceutics"></i>		
                        </figure>
                        <div class="hin-servicio-title">
                            <h4>{"Y mucho mas!"|x_translate}</h4>
                            <div class="hin-servicio-content">
                                <p>
                                    {"Envíe a su médico una solicitud de renovación de receta o recíbala después de una consulta por video si su médico lo considera necesario"|x_translate}
                                </p>
                            </div>
                        </div>

                    </div>
                </div>
                <a href="javascript:;" class="servicios pcuh-pf-slide-control right"><i class="icon-doctorplus-right-arrow"></i></a>

            </div>
        </div>
    </div>
</section>


{literal}

    <script type="text/javascript">
        $(document).ready(function () {

            if ($(window).width() <= 800) {
                $('.carousel-servicios').slick({
                    infinite: true,
                    arrows: true,
                    dots: false,
                    draggable: true,
                    nextArrow: '.servicios.pcuh-pf-slide-control.right',
                    prevArrow: '.servicios.pcuh-pf-slide-control.left',
                    edgeFriction: 1,
                    slidesToScroll: 1,
                    touchThreshold: 5,
                    useCSS: false,
                    autoplay: true,
                    autoplaySpeed: 3000
                });
            }



        });


    </script>

{/literal}
