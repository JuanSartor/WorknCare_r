{include file="paciente/menu.tpl"}

{include file="home/login.tpl"}

<!--	Funciond emostrar ocultar en script.js linea 1303-->

<!--Modales login	-->

<div class="hp-home-wrapper">
    <section class="okm-container hp-home">
        <div class="okm-row">
            <div class="hp-slide">
                <div class="hp-slide-item hp-slide-item-1">
                    <div class="hp-slide-inner-box">
                        <img src="{$IMGS}paciente/home/home-slide-1.jpg" title="slide-1"/>
                        <div class="hp-slide-data-box">
                            <p class="hp-slider-texto-3">
                                {"¿Estás resfriado y no puedes acercarte a una guardia?"|x_translate}
                            </p>
                            <p class="hp-slider-texto-1">
                                {"Tu salud no puede esperar..."|x_translate}<br> {"Consulta a un médico desde dónde estés"|x_translate}
                            </p>
                            <br>
                            <a href="{$url}patient/creer-un-compte.html" title='{"Registrarse"|x_translate}' class="hp-slide-action" id="consulta-express-trigger">
                                <figure>
                                    <i class="icon-doctorplus-chat"></i>
                                </figure>
                                <span>{"Envía una Consulta Express"|x_translate}</span>
                            </a>
                        </div>
                        <p class="hp-slide-foot">
                            {"Somos una plataforma que promueve las consultas a profesionales y a la no búsqueda de consejos por internet para solucionar cuestiones relacionadas a la salud."|x_translate}                        </p>
                    </div>
                </div>
                <div class="hp-slide-item hp-slide-item-2">
                    <div class="hp-slide-inner-box">
                        <img src="{$IMGS}paciente/home/home-slide-2.jpg" title="slide-2"/>
                        <div class="hp-slide-data-box">
                            <p class="hp-slider-texto-2 ">
                                {"Evita traslados innecesarios y la exposición a gérmenes en las salas de espera."|x_translate}
                            </p>
                            <p class="hp-slider-texto-3">
                                {"Un médico te atiende en vivo y en directo"|x_translate} <br>
                                {"a través de una Video Consulta."|x_translate}<br> 
                            </p>
                            <a href="{$url}patient/creer-un-compte.html" title='{"Registrarse"|x_translate}' class="hp-slide-action" id="consulta-video-trigger-1___">
                                <span class="pleft0">{"Abre tu cuenta y comienza a disfrutar de este servicio"|x_translate}</span>
                            </a>
                        </div>
                        <p class="hp-slide-foot">
                            {"Somos una plataforma que promueve las consultas a profesionales y a la no búsqueda de consejos por internet para solucionar cuestiones relacionadas a la salud."|x_translate}                     
                        </p>
                    </div>
                </div>
                <div class="hp-slide-item hp-slide-item-3 ">
                    <div class="hp-slide-inner-box">
                        <img src="{$IMGS}paciente/home/home-slide-3.jpg" title="slide-3"/>
                        <div class="hp-slide-data-box">
                            <p class="hp-slider-texto-2 ">
                                {"El historial clínico de tu familia en un solo lugar y siempre a tu alcance."|x_translate}
                            </p>
                            <p class="hp-slider-texto-3">
                                {"Más simple. Más cómodo. Más práctico"|x_translate}
                            </p>
                        </div>
                        <p class="hp-slide-foot">
                            {"Somos una plataforma que promueve las consultas a profesionales y a la no búsqueda de consejos por internet para solucionar cuestiones relacionadas a la salud."|x_translate}                     
                        </p>
                    </div>
                </div>
                <div class="hp-slide-item hp-slide-item-4">
                    <div class="hp-slide-inner-box">
                        <img src="{$IMGS}paciente/home/home-slide-4.jpg" title="slide-4"/>
                        <div class="hp-slide-data-box">
                            <p class="hp-slider-texto-1  ">{"¿Estas de viaje y queres continuar tus sesiones de terapia?"|x_translate}</p>
                            <p class="hp-slider-texto-3 ">
                                {"DoctorPlus te acerca a los especialistas del país"|x_translate}<br>
                                {"para que estés en contacto desde dónde estés."|x_translate}
                            </p>
                            <a href="{$url}patient/creer-un-compte.html" title='{"Registrarse"|x_translate}' class="hp-slide-action" id="consulta-video-trigger-2__">
                                <span>{"Registrarse como paciente"|x_translate}</span>
                            </a>
                        </div>
                        <p class="hp-slide-foot">
                            {"Somos una plataforma que promueve las consultas a profesionales y a la no búsqueda de consejos por internet para solucionar cuestiones relacionadas a la salud."|x_translate}                       
                        </p>
                    </div>
                </div>
                <div class="hp-slide-item hp-slide-item-5">
                    <div class="hp-slide-inner-box">
                        <img src="{$IMGS}paciente/home/home-slide-5.jpg" title="slide-5"/>
                        <div class="hp-slide-data-box">
                            <p class="hp-slider-texto-1   hp-left-text">
                                {"¿Estás en el exterior y necesitas hacer una consulta a un médico de confianza?"|x_translate}
                            </p>
                            <p class="hp-slider-texto-3  hp-left-text">
                                {"Contáctate en DoctorPlus con los especialistas de tu país"|x_translate}
                            </p>
                            <a href="{$url}patient/creer-un-compte.html" title='{"Registrarse"|x_translate}' id="ph-ce-slide-trigger-2___" class="hp-slide-action">
                                <span class="pleft0">{"Abre tu cuenta ahora mismo"|x_translate}</span>
                            </a>
                        </div>
                        <p class="hp-slide-foot">
                            {"Somos una plataforma que promueve las consultas a profesionales y a la no búsqueda de consejos por internet para solucionar cuestiones relacionadas a la salud."|x_translate}                 
                        </p>

                    </div>
                </div>
            </div>
        </div>
    </section>
</div>

<div class="hp-servicios-wrapper">	
    <section class="okm-container hp-servicios">
        <h2>{"Nuestros servicios para vos"|x_translate}</h2>
        <ul class="hp-servicios-control">
            <li><a href="#" id="srv-slide-0"><figure><i class="icon-doctorplus-chat"></i></figure></a></li>
            <li><a href="#" id="srv-slide-1"><figure><i class="icon-doctorplus-video-call"></i></figure></a></li>
            <li><a href="#" id="srv-slide-2"><figure><i class="icon-doctorplus-pharmaceutics"></i></figure></a></li>
            <li><a href="#" id="srv-slide-3"><figure><i class="icon-doctorplus-search"></i></figure></a></li>
            <li><a href="#" id="srv-slide-4"><figure><i class="icon-doctorplus-flag"></i></figure></a></li>
        </ul>

        <div class="hp-servicios-slide">
            <div class="servicios-item-1">
                <div class="hp-servicios-slide-inner">
                    <p class="txt-32">{"Consulta Express"|x_translate}</p>  
                    <p class="txt-18 txt-strong">{"Regístrate en el sitio, completa unas simples preguntas sobre tu salud y envía tu consulta a un especialista o publícala simultáneamente a todos los Profesionales de la misma especialidad que ofrezcan sus servicios en la plataforma. Te atenderá el primero disponible garantizándote una atención de calidad en el menor tiempo de espera."|x_translate}</p>
                    <div class="hp-servicios-action">
                        <a href="{$url}patient/creer-un-compte.html" title='{"Registrarse"|x_translate}' class="servicios-btn style1">{"COMENZAR"|x_translate}</a></div><br>
                    <img src="{$IMGS}paciente/servicios/slide-1.png"/>
                    <div class="hp-servicios-action">
                        <span href="#" id="ph-ce-slide-trigger" class="hp-servicios-action-foot">{"Otros beneficios de la Consulta Express"|x_translate}</span></div>

                </div>
                <div class="hp-consulta-express-slide-box" id="ph-ce-slide-target">
                    <div class="okm-row">
                        <div class="hp-ce-col">
                            <img src="{$IMGS}paciente/servicios/consulta-express-imagenes.png" title='{"Posibilidad de incluir imágenes"|x_translate}'/>
                            <h4>{"Posibilidad de incluir imágenes"|x_translate}</h4>
                            <p>
                                {"Puedes incluir imágenes en tu consulta para una mejor evaluación."|x_translate}
                            </p>
                        </div>
                        <div class="hp-ce-col">
                            <img src="{$IMGS}paciente/servicios/consulta-express-consultas.png" title='{"Historial de Consultas"|x_translate}'/>
                            <h4>{"Historial de Consultas"|x_translate}</h4>
                            <p> {"El profesional responderá por chat con mensajes de voz o texto. Al finalizar, el sistema te enviará sus conclusiones por mail. También quedará su registro médico en tu Perfil de Salud."|x_translate}
                            </p>
                        </div>
                        <div class="hp-ce-col">
                            <img src="{$IMGS}paciente/servicios/consulta-express-reintegro.png" title='{"Devolución en caso de cancelación"|x_translate}'/>
                            <h4>{"Devolución en caso de cancelación"|x_translate}</h4>
                            <p>
                                {"Si tu consulta no fue atendida en el plazo establecido, deseas cancelarla o el profesional concidera que necesitas mayor evaluación, el importe abonado será reintegrado en tu cuenta."|x_translate} 
                            </p>
                        </div>
                    </div>
                </div>

            </div>

            <div class="servicios-item-2">
                <div class="hp-servicios-slide-inner">
                    <p class="txt-32">
                        {"Video Consulta"|x_translate}
                    </p>
                    <p class="txt-16">
                        {"¿Estás enfermo y no querés esperar en una guardia? ¿Estas de viaje y no querés interrumpir tus vacaciones esperando la visita de un médico? ¿Necesitás hacerle una consulta a un médico de confianza?"|x_translate}
                    </p>
                    <p class="txt-24">
                        {"¡Una Video Consulta lo hace posible!"|x_translate}
                    </p>
                    <div class="hp-servicios-action">
                        <a href="{$url}patient/creer-un-compte.html" class="servicios-btn">{"COMIENZA A DISFRUTAR DE ESTE SERVICIO"|x_translate}</a>
                    </div> 
                    <br>
                    <img src="{$IMGS}paciente/servicios/slide-5.png"/>
                    <div class="hp-servicios-action">
                        <p><span href="#" id="ph-vc-slide-trigger" class="hp-servicios-action-foot hp-vc-footer">{"¿CÓMO SOLICITAR UNA VIDEO CONSULTA?"|x_translate}</span></p>
                    </div>
                </div>
                <div class="hp-consulta-express-slide-box" id="ph-vc-slide-target">
                    <div class="okm-row">
                        <div class="ph-vc-inner">
                            <p>
                                {"Desde tu celular o PC debes abrir una Cuenta Paciente en el sitio y completar unas simples preguntas obligatorias sobre tu salud. Luego podrás buscar al profesional de tu elección. Si tu consulta es de guardia podrás solicitar una Video Consulta Inmediata. Si no, podrás agendar un turno programado."|x_translate}
                            <p>
                                {"Del otro lado de la pantalla, te atenderá un especialista con quien podrás interactuar a través de un micrófono y cámara web. Una vez concluida la consulta, el profesional dejará registro de sus conclusiones y el sistema te los enviará por mail. También quedarán almacenados en tu Perfil de Salud."|x_translate}  
                            </p>
                        </div>
                    </div>
                </div>
            </div>

            <div class="servicios-item-3">
                <div class="hp-servicios-slide-inner">
                    <p class="txt-32">
                        {"Perfil de Salud"|x_translate}
                    </p>
                    <p class="txt-24">
                        {"¡Una aplicación que organizará el control y la gestión de tu salud!"|x_translate}
                    </p>
                    <p class="txt-16">
                        {"Envío de recordatorios de próximos chequeos, vacunas y turnos médicos. Almacenamiento del resultado de estudios. Registros de consultas médicas, diagnósticos y medicamentos."|x_translate}                    
                    </p>
                    <div class="hp-servicios-action">
                        <a href="{$url}patient/creer-un-compte.html" class="servicios-btn">{"Abre tu cuenta y comienza a disfrutar de este servicio"|x_translate}</a>
                    </div> <br><img src="{$IMGS}paciente/servicios/slide-4.png"/>
                </div>
            </div>

            <div class="servicios-item-4">
                <div class="hp-servicios-slide-inner">
                    <p class="txt-32">
                        {"Buscador de profesionales y turnos on line"|x_translate}
                    </p>
                    <p class="txt-24">
                        {"El contacto en forma directa con especialistas de todo el país."|x_translate}</p>
                    <p class="txt-16">
                        {"Agenda un turno de Video Consulta con un especialista en solo tres pasos. Sin gastos fijos, abona sólo cuando consultas. No demores tu consulta médica. SIMPLE. CÓMODO Y PRÁCTICO."|x_translate}</p>
                    <div class="hp-servicios-action">
                        <a href="{$url}patient/creer-un-compte.html" class="servicios-btn">{"COMENZAR"|x_translate}</a><br>
                    </div><br>           <img src="{$IMGS}paciente/servicios/slide-3.png"/>
                </div>
            </div>

            <div class="servicios-item-5">
                <div class="hp-servicios-slide-inner">
                    <p class="txt-32">
                        {"Notificaciones de Salud"|x_translate}
                    </p>
                    <p class="txt-24">
                        {"Te ayudamos a cuidar mejor de tu salud"|x_translate}
                    </p>
                    <p class="txt-16">
                        {"Recibe avisos de tus próximos controles y chequeos, recordatorios de vacunas y consejos sobre vida saludable y bienestar."|x_translate}</p>
                    <div class="hp-servicios-action">
                        <a href="{$url}patient/creer-un-compte.html" class="servicios-btn">{"COMENZAR"|x_translate}</a>
                    </div><br>
                    <img src="{$IMGS}paciente/servicios/slide-2.png"/>
                </div>
            </div>

        </div>	
    </section>
</div>

<section class="okm-container hp-plus-ayuda">
    <div class="okm-row">
        <h2>{"¡DoctorPlus te ayuda a cuidar tu salud!"|x_translate}<br>{"Accede desde tu celular o PC sin descargas ni instalaciones."|x_translate}</h2>
    </div>
    <div class="okm-row">
        <div class="hp-pa-col">
            <div class="hp-pa-img-box">
                <img src="{$IMGS}paciente/servicios/avisos-y-recordatorios.jpg" title='{"Recibir avisos y recordatorios"|x_translate}'/>
            </div>
            <h4>{"Recibe avisos y recordatorios"|x_translate}</h4>
            <p>
                {"Una plataforma de salud que te ayuda a recordar las próximas vacunas de tus hijos, tus chequeos y controles médicos anuales. Almacena tu historial clínico y el de tu familia en un solo lugar"|x_translate}</p>
        </div>

        <div class="hp-pa-col">
            <div class="hp-pa-img-box">
                <img src="{$IMGS}paciente/servicios/profesionales-en-la-red.jpg" title='{"Profesionales en la red"|x_translate}'/>
            </div>
            <h4>{"¡Abona solo cuando consultas!"|x_translate}</h4>
            <p>
                {"Sin intermediarios, consulta directamente a los médicos especialistas. Accede a nuestro servicio con tu cobertura o abona la consulta con tarjeta de crédito"|x_translate} </p>
        </div>
    </div>
    <div class="okm-row">
        <div class="hp-pa-profesionales">
            <figure>
                <i class="icon-doctorplus-people-add"></i>
            </figure>
            <h4>{"Profesionales Frecuentes"|x_translate}</h4>
            <p>
                {"Los médicos y profesionales a cargo de tu salud ahora podrán estar conectados a traves de DoctorPlus. Enviarse mensajes, compartir imágenes e intercambiar opiniones para brindarte una mejor calidad de atención médica integral."|x_translate}
            </p>
        </div>
    </div>
</section>

<section class="consulta-express-slider-holder">

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
                                    <p>{"Consultá a tus médicos de confianza sin moverte de tu casa o el trabajo"|x_translate}</p>
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
                                    <p>{"Comience a disfrutar de los beneficios de DoctorPlus. La nueva red de e-Salud que conecta a médicos y pacientes"|x_translate}
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
                            <h3>{"Mucho más que una app"|x_translate}</h3>
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
                                    <h4>{"DoctorPlus no requiere descargas ni instalación."|x_translate}</h4>
                                    <p>
                                        {"Una WebApp accesible desde cualquier dispositivo celular, tablet o pc con conexión a internet."|x_translate}
                                    </p>
                                    <div class="item-3-content-link-holder">
                                        <a class="item-3-content-link" href="{$url}patient/creer-un-compte.html" title='{"Registrarse"|x_translate}'>{"¡Abre tu cuenta ahora!"|x_translate} <span></span></a>
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
                                    <p> {"¡Tu salud no puede esperar!"|x_translate}
                                    </p>
                                    <p>
                                        {"En DoctorPlus podrás enviar tus consultas a varios especialistas en simultáneo. Te atenderá el primero disponible."|x_translate}  
                                    </p>
                                    <div class="item-3-content-link-holder">
                                        <a  class="item-3-content-link" href="{$url}patient/creer-un-compte.html" title='{"Registrarse"|x_translate}'>{"¡Envía tu consulta ahora!"|x_translate} <span></span> </a>
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
            <li data-target="#consulta-express-slider" data-slide-to="2"></li>
            <li data-target="#consulta-express-slider" data-slide-to="3"></li>
        </ol>
        <!-- Controls -->
    </div>
    <div class="consulta-express-slider-foot">
        <span>{"Las herramientas de DoctorPlus no deben ser utilizadas ante emergencias o casos severos que puedan suponer un riesgo de vida para el paciente."|x_translate}</span>
    </div>



</section>
{include file="home/contactenos.tpl"}

<script>
    $(function () {
        function mulScroll(trgObj) {
            var trgObjHeight = trgObj.outerHeight();
            $('html, body').animate({
                scrollTop: (trgObj.offset().top - trgObjHeight) - 60
            }, 1000);
        }

        $(':checkbox').radiocheck();
        $(':radio').radiocheck();
        /*
         $('.paciente-nav-trigger').on('click', function (e) {
         e.preventDefault();
         $pacienteMenu = $('#paciente-menu');
         $pacienteMenu.toggleClass('menu-show');
         
         });
         
         
         $('.paciente-nav-menu-burger').on('click', function (e) {
         e.preventDefault();
         var vpw = $(window).width() + getScrollBarWidth();
         $burgerMenu = $('#burger-menu');
         $burgerMenu.toggleClass('menu-show');
         });*/


        $(document).on('click', function (event) {
            if ((!$(event.target).closest('.paciente-nav-trigger').length)) {
                $('#paciente-menu').removeClass('menu-show');
            }
            if ((!$(event.target).closest('.paciente-nav-menu-burger').length)
                    &&
                    $('.paciente-nav-menu-burger').is(':visible')) {
                $('#burger-menu').removeClass('menu-show');
            }
        });

        $(window).on('scroll', function () {
            var currentTop = $(window).scrollTop();

            if (currentTop >= 60) {
                $('.paciente-nav').addClass('transparent');
            } else if (currentTop < 60) {
                $('.paciente-nav').removeClass('transparent');
            }

        });


        function scrollToObj(trgObj) {
            var trgObjHeight = trgObj.outerHeight();
            $('html, body').animate({
                scrollTop: trgObj.offset().top - trgObjHeight
            }, 1000);
        }

//inicializamos los sliders
        $('.hp-slide').slick({
            dots: true,
            infinite: true,
            speed: 300,
            autoplay: true,
            autoplaySpeed: 8000,
            pauseOnFocus: true,
            pauseOnHover: true,
            pauseOnDotsHover: true
        });

        $('.hp-servicios-slide').slick({
            dots: false,
            infinite: true,
            speed: 300,
            arrows: false,
            autoplay: true,
            autoplaySpeed: 8000,
            adaptiveHeight: true,
            pauseOnFocus: true,
            pauseOnHover: true,
            pauseOnDotsHover: true
        });
        //detiene los sliders al hacer click
        $('.hp-servicios-slide,.hp-slide').on('swipe', function (event, slide, direction) {
            slide.slickSetOption('autoplay', false);
        });

        $('.hp-servicios-slide').find('.slick-dots').find('button').on('click', function (e) {
            $('.hp-servicios-slide').slick('slickSetOption', 'autoplay', false, true);
        });
        $('.hp-slide').find('.slick-dots').find('button').on('click', function (e) {
            $('.hp-slide').slick('slickSetOption', 'autoplay', false, true);
        });

        $('#srv-slide-0').on('click', function (e) {
            e.preventDefault();
            $('.hp-servicios-slide').slick('slickGoTo', 0);
            $('.hp-servicios-slide').slick('slickSetOption', 'autoplay', false, true);
        });

        $('#srv-slide-1').on('click', function (e) {
            e.preventDefault();
            $('.hp-servicios-slide').slick('slickGoTo', 1);
            $('.hp-servicios-slide').slick('slickSetOption', 'autoplay', false, true);
        });

        $('#srv-slide-2').on('click', function (e) {
            e.preventDefault();
            $('.hp-servicios-slide').slick('slickGoTo', 2);
            $('.hp-servicios-slide').slick('slickSetOption', 'autoplay', false, true);
        });

        $('#srv-slide-3').on('click', function (e) {
            e.preventDefault();
            $('.hp-servicios-slide').slick('slickGoTo', 3);
            $('.hp-servicios-slide').slick('slickSetOption', 'autoplay', false, true);
        });

        $('#srv-slide-4').on('click', function (e) {
            e.preventDefault();
            $('.hp-servicios-slide').slick('slickGoTo', 4);
            $('.hp-servicios-slide').slick('slickSetOption', 'autoplay', false, true);
        });



        $('#consulta-express-trigger, #ph-ce-slide-trigger-2').on("click", function (e) {
            e.preventDefault();
            scrollToObj($('#srv-slide-0'));
            $('.hp-servicios-slide').slick('slickGoTo', 0);
        });

        $('#consulta-video-trigger-1, #consulta-video-trigger-2').on("click", function (e) {
            e.preventDefault();
            scrollToObj($('#srv-slide-1'));
            $('.hp-servicios-slide').slick('slickGoTo', 1);
        });
    });
</script>


