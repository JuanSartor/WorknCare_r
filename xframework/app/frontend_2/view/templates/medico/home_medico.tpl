{include file="medico/menu.tpl"}

{include file="home/login.tpl"}
<input type="hidden" id="load_login" value="{$load_login}"/>





<!--	Funciond emostrar ocultar en script.js linea 1303-->

<!--Modales login	-->	


<section class="hom-slider-box full-width">

    <div class="hom-slide" style="max-height:800px;">

        <div class="hom-slide-item-1 slide-full" style="background-image:url('{$IMGS}medico/new-home-medico-1.jpg')">
            <div class="hom-slide-inner-box" >
                <div class="hom-slide-data-box">
                    <p>{"Brinde una atención médica de calidad a pacientes que no pueden acercarse hasta su consultorio."|x_translate}</p>
                </div>
                <div class="hom-slide-footer">{"Las herramientas de telemedicina que brinda WorknCare no deben ser utilizadas para tratar emergencias ni temas complejos de salud."|x_translate}</div>
            </div>
        </div>

        <div class="hom-slide-item-2 slide-full" style="background-image:url('{$IMGS}medico/new-home-medico-2.jpg')">
            <div class="hom-slide-inner-box">
                <div class="hom-slide-data-box">
                    <h2>{"¡Basta de consultas por teléfono, mail o wspp!"|x_translate}</h2>
                    <p>{"Atienda consultas sobre temas cotidianos en forma inmediata en el marco formal y legal de un sitio que le ofrece la posibilidad de responder como si estuviese en su consultorio."|x_translate}</p>
                </div>
                <div class="hom-slide-footer">{"Las herramientas de telemedicina que brinda WorknCare no deben ser utilizadas para tratar emergencias ni temas complejos de salud."|x_translate}</div>
            </div>
        </div>


        <div class="hom-slide-item-3 slide-full" style="background-image:url('{$IMGS}medico/new-home-medico-3.jpg')">
            <div class="hom-slide-inner-box">
                <div class="hom-slide-data-box">
                    <h2>{"Conectados ayudamos a los pacientes a cuidar mejor su salud"|x_translate}</h2>
                    <span>{"DoctorPlus es un nuevo canal de comunicación entre médicos y pacientes que  incentiva y facilita su relación."|x_translate}</span></div>
                <div class="hom-slide-footer">{"Las herramientas de telemedicina que brinda WorknCare no deben ser utilizadas para tratar emergencias ni temas complejos de salud."|x_translate}</div>
            </div>
        </div>


    </div>

    <div class="hom-slider-contact-box">
        <form id="form_contacto" action="{$url}professionnel/creer-un-compte.html" method="POST">
            <input type="hidden" name="email" id="email_f" />
        </form>	


        <div class="hom-contacto-input-holder">
            <input type="text" name="email" id="email_input" tabindex="1" placeholder='{"Ingrese su correo electrónico"|x_translate}'/>
            <figure>
                <i class="icon-doctorplus-envelope"></i>
            </figure>
        </div>
        <div class="hom-contacto-action-holder">
            <button id="btnEmpezar" class="btn-alert">{"¡Empezar!"|x_translate}</button>
        </div>

    </div>

</section>

<div id="hom-solucion"></div>
<section class="hom-solucion-integral">
    <h1 class="anim-txt-1">
        {"Complementamos los sistemas tradicionales y ofrecemos un nuevo canal para la atención médica de pacientes."|x_translate} </h1>  
    <div class="hom-soluciones-divider anim-txt-3">
        <i class="icon-doctorplus-arrow-down"></i>    </div>
    <p class="anim-txt-2">
        {"Su consultorio médico portátil  a través de un entorno seguro y confiable que le permite acceder en todo momento al Perfil de Salud del paciente y a sus registros médicos."|x_translate}</p>
    <p class="anim-txt-1">
        {"Optimice sus tiempos de trabajo. Flexibilice su agenda de turnos y atienda a más pacientes."|x_translate}</p>
</section><div id="hom-funcionalidades"></div>
<section class="hom-servicios">
    <div class="hom-servicios-list-menu">
        <h2 id="hom-funcionalidades">{"¡Conozca las funcionalidades disponibles para ud.!"|x_translate}</h2>
        <ul>
            <li class="anim-funcionalidad">
                <a href="javascript:;" data-srv="consultaexpress">
                    <figure>
                        <i class="icon-doctorplus-chat"></i>
                    </figure>
                    <span>{"Consulta Express"|x_translate}</span>
                </a>
            </li>
            <li class="anim-funcionalidad">
                <a href="javascript:;" data-srv="videoconsulta">
                    <figure>
                        <i class="icon-doctorplus-video-call"></i>
                    </figure>
                    <span>{"Video Consulta"|x_translate}</span>
                </a>
            </li>
            <li class="anim-funcionalidad">
                <a href="javascript:;" data-srv="buscadordeprofesionales">
                    <figure>
                        <i class="icon-doctorplus-search"></i>
                    </figure>
                    <span>{"Buscador de profesionales"|x_translate}</span>
                </a>
            </li>
            <li class="anim-funcionalidad">
                <a href="javascript:;" data-srv="historiaclinica">
                    <figure>
                        <i class="icon-doctorplus-pharmaceutics"></i>
                    </figure>
                    <span>{"Historia Clínica"|x_translate}</span>
                </a>
            </li>

            <li class="anim-funcionalidad">
                <a href="javascript:;" data-srv="agendadeturnos">
                    <figure>
                        <i class="icon-doctorplus-calendar"></i>
                    </figure>
                    <span>{"Agenda de turnos"|x_translate}</span>
                </a>
            </li>
            <li class="anim-funcionalidad">
                <a href="javascript:;" data-srv="gestiondepacientes">
                    <figure>
                        <i class="icon-doctorplus-pacientes"></i>
                    </figure>
                    <span>{"Gestión de pacientes"|x_translate}</span>
                </a>
            </li>
        </ul>
    </div>

    <div>
        <div class="hom-servicios-list">
            <div id="consultaexpress"></div>
            <div class="hom-servicios-list-prof">
                <div class="hom-servicios-list-prof-inner">
                    <div class="hom-servicios-list-prof-card">
                        <h2>
                            <i class="icon-doctorplus-right-arrow"></i>
                            {"Consulta Express"|x_translate}
                        </h2>
                        <p class="bajada anim-ce">
                            {"¡Atienda desde su celular sin necesidad de brindar su número!"|x_translate}</p>
                        <p class="anim-ce">
                            {"Una solución de mensajería instantánea especialmente desarrollada para el ámbito de la salud. Un canal formal, seguro y confiable. El chat de la consulta queda adjunto a su registro médico en la Historia Clínica del paciente"|x_translate}</p>
                        <div class="lnk-holder anim-ce">
                            <a href="javascript:;">
                                <figure><i class="icon-doctorplus-people-add"></i></figure>
                                <span>{"PROFESIONALES EN LA RED"|x_translate}</span>
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <div id="videoconsulta"></div>
            <div class="hom-servicios-slide-item-2">
                <h2 class="hom-servicios-title">
                    <i class="icon-doctorplus-right-arrow"></i>
                    {"Video Consulta"|x_translate}
                </h2>
                <p class="text-red anim-vc-1">
                    {"Atienda consultas en forma remota con la misma privacidad de un consultorio particular. Genere un nuevo canal de atención médica y tenga llegada a más pacientes."|x_translate}</p>
                <img class="anim-vc-2" src="{$IMGS}medico/hom-servicios/servicios-slide-2.png" alt="Video Consulta"/>
                <div class="hom-servicios-video-footer">

                    <figure class="hom-servicios-video-footer-icon anim-vc-3">
                        <img src="{$IMGS}home/medicos/video-consulta-icon.png"/>
                    </figure>

                    <div class="hom-servicios-video-footer-content anim-vc-4">
                        <h4>{"Marco legal y seguro"|x_translate}</h4>
                        <p>
                            {"Los datos almacenados son encriptados y las comunicaciones transcurren via SSL. Las Video Consultas no son grabadas ni almacenadas."|x_translate}
                        </p>
                    </div>

                </div>
            </div>

            <div id="buscadordeprofesionales"></div>
            <div id="agendadeturnos"></div>
            <div class="hom-servicios-slide-item-3">
                <h2 class="hom-servicios-title">
                    <i class="icon-doctorplus-right-arrow"></i>
                    {"Buscador de profesionales y agenda de turnos on line"|x_translate}
                </h2>
                <p class="text-red anim-bc-1">
                    {"¡EL TELETRABAJO DE LOS PROFESIONALES DE LA SALUD AHORA ES POSIBLE!"|x_translate}</p>
                <div class="okm-container">
                    <div class="okm-row hom-servicios-mobile-row">

                        <figure class="hom-servicios-mobile-img-box anim-bc-2">
                            <img src="{$IMGS}home/medicos/mobile.png" alt="Doctor Plus mobile"/>
                        </figure>

                        <div class="hom-servicios-mobile-first-col">
                            <p class="anim-bc-3">
                                {"Ofrezca sus servicios profesionales y brinde atención médica a pacientes de todo el país o de viaje en el extranjero."|x_translate}</p>
                        </div>

                        <div class="hom-servicios-mobile-second-col">
                            <p class="anim-bc-4">
                                {"Gestione su agenda de turnos presenciales y de su consultorio virtual. Aproveche sus tiempos libres."|x_translate}</p>
                        </div>
                    </div>
                </div>
            </div>
            <div id="historiaclinica"></div>
            <section class="hom-servicios-perfil-salud">
                <div class="hom-servicios-perfil-salud-caracteristicas">
                    <div class="okm-container">
                        <div class="okm-row hom-spf-caracteristicas-row">
                            <br>
                            <div class="hom-spf-caracteristicas-item">
                                <figure class="anim-bc-5">
                                    <i class="icon-doctorplus-check-thin"></i>
                                </figure>
                                <p class="anim-bc-6">{"Avisos recordatorios de turnos para reducir el ausentismo."|x_translate}</p>				
                            </div>

                            <div class="hom-spf-caracteristicas-item">
                                <figure class="anim-bc-5">
                                    <i class="icon-doctorplus-check-thin"></i>
                                </figure>
                                <p class="anim-bc-6">{"Alta automática de disponibilidad de turnos cancelados por el paciente."|x_translate}</p>				
                            </div>

                            <div class="hom-spf-caracteristicas-item">
                                <figure class="anim-bc-5">
                                    <i class="icon-doctorplus-check-thin"></i>
                                </figure>
                                <p class="anim-bc-6">{"Gestión de agenda desde cualquier dispositivo."|x_translate}</p>				
                            </div>

                        </div>
                    </div>
                </div>

                <div class="hom-spf">

                    <h2 class="hom-servicios-title">
                        <i class="icon-doctorplus-right-arrow"></i>
                        {"Perfil de Salud"|x_translate}
                    </h2>
                    <p class="anim-hc-1"> {"¡No más fichas en papel!"|x_translate}<BR> {"El almacenamiento seguro de sus registros médicos y la historia clínica de los pacientes y la posibilidad de compartir sus opiniones con otros colegas de todo el país."|x_translate} 
                    </p>

                    <div class="hom-spf-registros-medicos">
                        <figure class="anim-hc-2">
                            <img src="{$IMGS}home/medicos/perfil-salud.png" alt="Doctor Plus perfil salud"/>
                        </figure>
                        <p class="anim-hc-3">
                            {"Posibilidad de establecer contacto con decena de pares para brindar tratamientos más integrales, derivaciones, etc."|x_translate}
                        </p>
                    </div>

                </div>

            </section>

            <div id="gestiondepacientes"></div>
            <div class="hom-servicios-slide-item-5">
                <h2 class="hom-servicios-title">
                    <i class="icon-doctorplus-right-arrow"></i>
                    {"Gestión de pacientes"|x_translate}
                </h2>
                <h3 class="anim-pc-1">{"Interactúe con sus pacientes sin necesidad de llamadas telefónicas:"|x_translate}</h3>

                <div class="okm-row hom-slide-box">
                    <div class="hom-slide-img-box anim-pc-2">
                        <img src="{$IMGS}home/medicos/pacientes.png" title='{"Gestión de pacientes"|x_translate}'/>
                    </div>
                    <div class="hom-slide-content-box">
                        <ul>
                            <li class="anim-pc-3">
                                <i class="icon-doctorplus-check-thin"></i> 
                                <p>
                                    {"Notificaciones por renovación de recetas."|x_translate}
                                </p>
                            </li>
                            <li class="anim-pc-3">
                                <i class="icon-doctorplus-check-thin"></i> 
                                <p>
                                    {"Solicitud de certificados y aptos médicos."|x_translate}
                                </p>
                            </li>
                            <li class="anim-pc-3">
                                <i class="icon-doctorplus-check-thin"></i> 
                                <p>
                                    {"Envío de mensajes o consejos médicos por mail sin necesidad de brindar sus datos de casilla de mail o celular."|x_translate}
                                </p>
                            </li>
                        </ul>
                    </div>
                </div>
            </div>


        </div>


    </div>
</section>	


<section class="account-order hom-planes" >
    <div class="container">
        <h1 id="hom-planes" class="text-center">{"Tipos de cuentas"|x_translate}</h1>
        <h2 class="text-center">{"Los planes más convenientes de acuerdo a sus necesidades"|x_translate}</h2>
        <div class="row">

            <div class="col-md-8 col-md-offset-2">
                <div class="row">
                    <div class="col-md-6">
                        <div class="highlight-box text-center">
                            <small>{"Cuenta Básica"|x_translate}</small>
                            <div class="price">
                                <span>{"Gratis"|x_translate}</span>
                                <span></span>
                            </div>
                            <a href="{$url}professionnel/creer-un-compte.html" role="button">{"Adquirir"|x_translate}</a>
                        </div>
                    </div>
                    <div class="col-md-6">
                        <div class="highlight-box text-center">
                            <small>{"Cuenta Profesional"|x_translate}</small>
                            <div class="price">
                                <span>&euro;{$MONTO_CUOTA}</span>
                                <span>{"FINAL/MES"|x_translate}</span>
                            </div>
                            <a href="{$url}professionnel/creer-un-compte.html" role="button">{"Adquirir"|x_translate}</a>
                        </div>
                    </div>
                </div>
                <div class="hom-planes-btn-box">
                    <button id="compare-btn" class="uppercase">{"Comparar planes"|x_translate}</button>
                </div>
            </div>
        </div>
        <div id="comparison-table" class="comparison-table">
            <table class="table table-rsp hom-planes-table">
                <tr>
                    <th>{"Tipo de cuenta"|x_translate}</th>
                    <th><span>{"Cuenta Gratuita"|x_translate}</span></th>
                    <th><span>{"Cuenta Profesional"|x_translate}</span></th>
                </tr>
                <tr>
                    <td>{"Agenda de Turnos on line"|x_translate}</td>
                    <td><span class="check"></span></td>
                    <td><span class="check"></span></td>
                </tr>
                <tr>
                    <td>{"Recordatorios de turnos por email y sms"|x_translate}</td>
                    <td><span class="check"></span></td>
                    <td><span class="check"></span></td>
                </tr>
                <tr>
                    <td>{"Acceso a la Info de Salud de sus pacientes desde cualquier dispositivo"|x_translate}</td>
                    <td><span class="check"></span></td>
                    <td><span class="check"></span></td>
                </tr>
                <tr>
                    <td>{"Registro de sus consultas médicas a distancia"|x_translate}</td>
                    <td><span class="check"></span></td>
                    <td><span class="check"></span></td>
                </tr>
                <tr>
                    <td>{"Consulta Express"|x_translate}</td>
                    <td><span class="red">{$COMISION_CE}% {"comisión"|x_translate}<sup>(1)</sup></span></td>
                    <td><span class="check"></span></td>
                </tr>
                <tr>
                    <td>{"Video Consulta"|x_translate}</td>
                    <td><span class="red">{$COMISION_VC}% {"comisión"|x_translate}<sup>(1)</sup></span></td>
                    <td><span class="check"></span></td>
                </tr>
                <tr>
                    <td>{"Gestión de pacientes"|x_translate}</td>
                    <td><span class="check"></span></td>
                    <td><span class="check"></span></td>
                </tr>
                <tr>
                    <td>{"Contacto con los médicos frecuentes del paciente"|x_translate}</td>
                    <td><span class="check"></span></td>
                    <td><span class="check"></span></td>
                </tr>
                <tr>
                    <td>{"Envío de consejos médicos"|x_translate}</td>
                    <td><span class="check"></span></td>
                    <td><span class="check"></span></td>
                </tr>
                <tr>
                    <td>{"50 pacientes con servicio de CE bonificado(2)"|x_translate}</td>
                    <td><span class="cross"></span></td>
                    <td><span class="check"></span></td>
                </tr>
                <tr>
                    <td>{"Soporte Técnico"|x_translate}</td>
                    <td><span class="check"></span></td>
                    <td><span class="check"></span></td>
                </tr>
            </table>
            <small class="pull-right">
                <sup>(1)</sup>{"Costes operativos todo incluido. ¡OPTA POR LA SUSCRIPCIÓN DE 10 CONSULTAS POR MES!"|x_translate}<br>
                <sup>(2)</sup>{"Hasta 50 (cincuenta) pacientes bonificados para sus servicios de Consulta Express."|x_translate}
            </small>
        </div>
    </div>
</section>



{include file="home/contactenos.tpl"}	
<script type="text/javascript" src="{$url_js_libs}/greensock-js/minified/TweenMax.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}/greensock-js/minified/jquery.gsap.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}/greensock-js/minified/plugins/CSSPlugin.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}/scrollmagic/minified/ScrollMagic.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}/scrollmagic/minified/plugins/jquery.ScrollMagic.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}/scrollmagic/minified/plugins/animation.gsap.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}/scrollmagic/minified/plugins/debug.addIndicators.min.js"></script>

{literal}
    <script>
        $(function () {
            //si viene dirigido desde el mail de validacion de cuenta, ya mostramos el modal de login
            if ($("#load_login").val() == 1) {
                $("#loginbtn").trigger("click");
            }
            $("#btnEmpezar").click(function () {
                //expresion regular para mail
                if (!validarEmail($("#email_input").val())) {
                    $("#email_input").data("title", x_translate("Ingrese un email válido"))
                            .tooltip("show");
                    return false;
                }
                $("#email_f").val($("#email_input").val());
                $('#form_contacto').submit();
            });





            function mulScroll(trgObj) {
                var trgObjHeight = trgObj.outerHeight();
                $('html, body').animate({
                    scrollTop: (trgObj.offset().top - trgObjHeight) - 60
                }, 1000);
            }


            //slider

            $('.hom-servicios-slide').slick({
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
            $('.hom-slide').slick({
                dots: true,
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
            //detener el slider
            $('.hslide').on("click", function (e) {
                e.preventDefault();
                //scrollToObj($('#srv-slide-0'));
                var slideNumer = $(this).data('slide');
                $('.hom-servicios-slide').slick('slickGoTo', slideNumer);
                $('.hom-servicios-slide').slick('slickPause');
                $('.hom-servicios-slide').slick('slickSetOption', 'autoplay', false, true);

            });

            $('.hom-servicios-slide').on('swipe', function (event, slide, direction) {
                $('.hom-servicios-slide').slick('slickSetOption', 'autoplay', false, true);
                $('.swipe-icon-box').hide();
            });


            $('.hom-slide').on('swipe', function (event, slide, direction) {
                slide.slickSetOption('autoplay', false);
            });


            $('.hom-slide').find('.slick-dots').find('button').on('click', function (e) {
                $('.hom-slide').slick('slickSetOption', 'autoplay', false, true);
            });





            /*
             $('#hom-nav-rsp-trg').on('click', function (e) {
             e.preventDefault();
             
             $('#hom-nav-rsp-get').toggleClass('menu-show');
             
             });
             */
            $(window).on('scroll', function () {
                var currentTop = $(window).scrollTop();

                if (currentTop >= 60) {
                    $('.hom-nav').addClass('transparent');
                } else if (currentTop < 60) {
                    $('.hom-nav').removeClass('transparent');
                }

            });




            var menuEl = $('#hom-nav-rsp-get').children('li').children('a');

            menuEl.on('click', function (e) {


                if (typeof $(this).data('lnk') !== 'undefined') {
                    var lnkTo = "#" + $(this).data('lnk');
                    mulScroll($(lnkTo));
                }


                if ($('#hom-nav-rsp-get').hasClass('menu-show')) {
                    $('#hom-nav-rsp-get').removeClass('menu-show');
                }

            });

            if ($('.hom-solucion-integral').length > 0) {
                //--

                var controller = new ScrollMagic.Controller();

                // textos soluciones
                var tweenTextSolucion1 = TweenMax.staggerFromTo(".anim-txt-1", 0.5, {opacity: 0}, {opacity: 1}, 0.0);
                var tweenTextSolucion2 = TweenMax.staggerFromTo(".anim-txt-2", 0.3, {opacity: 0}, {opacity: 1}, 0.1);
                var tweenTextSolucion3 = TweenMax.staggerFromTo(".anim-txt-3", 0.3, {opacity: 0}, {opacity: 1}, 0.0);
                var tweenTextSolucion4 = TweenMax.staggerFromTo(".anim-txt-4", 0.3, {opacity: 0}, {opacity: 1}, 0.1);

                var timelineSolucion = new TimelineMax();

                timelineSolucion
                        .add(tweenTextSolucion1)
                        .add(tweenTextSolucion2)
                        .add(tweenTextSolucion3)
                        .add(tweenTextSolucion4);


                var scene = new ScrollMagic.Scene({triggerElement: "#hom-solucion"})
                        .setTween(timelineSolucion)
                        //.addIndicators() 
                        .reverse(false)
                        .addTo(controller);



                var tweenfuncionalidades = TweenMax.staggerFromTo(".anim-funcionalidad", 1, {rotationY: 90, transformOrigin: "50% 50%"}, {rotationY: 0, transformOrigin: "50% 50%", ease: Back.easeOut}, 0.15);

                var scene = new ScrollMagic.Scene({triggerElement: "#hom-funcionalidades"})
                        .setTween(tweenfuncionalidades)
                        //.addIndicators()
                        .reverse(false)
                        .addTo(controller);


                var tweenCE = TweenMax.staggerFromTo(".anim-ce", 1, {rotationX: 90, transformOrigin: "50% 50%"}, {rotationX: 0, transformOrigin: "50% 50%", ease: Back.easeOut}, 0.25);

                var scene = new ScrollMagic.Scene({triggerElement: "#consultaexpress"})
                        .setTween(tweenCE)
                        //.addIndicators()
                        .reverse(false)
                        .addTo(controller);



                var tweenVC1 = TweenMax.staggerFromTo(".anim-vc-1", 1, {rotationX: 90, transformOrigin: "50% 50%"}, {rotationX: 0, transformOrigin: "50% 50%", ease: Back.easeOut}, 0.25);
                var tweenVC2 = TweenMax.staggerFromTo(".anim-vc-2", 0.3, {opacity: 0}, {opacity: 1}, 0.1);
                var tweenVC3 = TweenMax.staggerFromTo(".anim-vc-3", 0.5, {rotationY: 90, transformOrigin: "50% 50%"}, {rotationY: 0, transformOrigin: "50% 50%", ease: Back.easeOut}, 0.25);
                var tweenVC4 = TweenMax.staggerFromTo(".anim-vc-4", 0.3, {opacity: 0}, {opacity: 1}, 0.1);

                var timelineVC = new TimelineMax();

                timelineVC
                        .add(tweenVC1)
                        .add(tweenVC2)
                        .add(tweenVC3)
                        .add(tweenVC4);

                var scene = new ScrollMagic.Scene({triggerElement: "#videoconsulta"})
                        .setTween(timelineVC)
                        //.addIndicators()
                        .reverse(false)
                        .addTo(controller);



                var tweenBC1 = TweenMax.staggerFromTo(".anim-bc-1", 1, {rotationX: 90, transformOrigin: "50% 50%"}, {rotationX: 0, transformOrigin: "50% 50%", ease: Back.easeOut}, 0.25);
                var tweenBC2 = TweenMax.staggerFromTo(".anim-bc-2", 0.3, {rotationY: 90, transformOrigin: "50% 50%"}, {rotationY: 0, transformOrigin: "50% 50%", ease: Back.easeOut}, 0.25);
                var tweenBC3 = TweenMax.staggerFromTo(".anim-bc-3", 0.5, {opacity: 0}, {opacity: 1}, 0.1);
                var tweenBC4 = TweenMax.staggerFromTo(".anim-bc-4", 0.3, {opacity: 0}, {opacity: 1}, 0.1);
                var tweenBC5 = TweenMax.staggerFromTo(".anim-bc-5", 0.2, {rotationY: 90, transformOrigin: "50% 50%"}, {rotationY: 0, transformOrigin: "50% 50%", ease: Back.easeOut}, 0.15);
                var tweenBC6 = TweenMax.staggerFromTo(".anim-bc-6", 0.2, {rotationX: 90, transformOrigin: "50% 50%"}, {rotationX: 0, transformOrigin: "50% 50%", ease: Back.easeOut}, 0.15);



                var timelineBC = new TimelineMax();

                timelineBC
                        .add(tweenBC1)
                        .add(tweenBC2)
                        .add(tweenBC3)
                        .add(tweenBC4)
                        .add(tweenBC5)
                        .add(tweenBC6);

                var scene = new ScrollMagic.Scene({triggerElement: "#buscadordeprofesionales"})
                        .setTween(timelineBC)
                        //.addIndicators()
                        .reverse(false)
                        .addTo(controller);



                var tweenHC1 = TweenMax.staggerFromTo(".anim-hc-1", 1, {rotationY: 90, transformOrigin: "50% 50%"}, {rotationY: 0, transformOrigin: "50% 50%", ease: Back.easeOut}, 0.25);
                var tweenHC2 = TweenMax.staggerFromTo(".anim-hc-2", 0.3, {opacity: 0}, {opacity: 1}, 0.1);
                var tweenHC3 = TweenMax.staggerFromTo(".anim-hc-3", 0.5, {rotationX: 90, transformOrigin: "50% 50%"}, {rotationX: 0, transformOrigin: "50% 50%", ease: Back.easeOut}, 0.25);

                var timelineHC = new TimelineMax();

                timelineHC
                        .add(tweenHC1)
                        .add(tweenHC2)
                        .add(tweenHC3);

                var scene = new ScrollMagic.Scene({triggerElement: "#historiaclinica"})
                        .setTween(timelineHC)
                        //.addIndicators()
                        .reverse(false)
                        .addTo(controller);


                var tweenPC1 = TweenMax.staggerFromTo(".anim-pc-1", 1, {rotationY: 90, transformOrigin: "50% 50%"}, {rotationY: 0, transformOrigin: "50% 50%", ease: Back.easeOut}, 0.25);
                var tweenPC2 = TweenMax.staggerFromTo(".anim-pc-2", 0.3, {opacity: 0}, {opacity: 1}, 0.1);
                var tweenPC3 = TweenMax.staggerFromTo(".anim-pc-3", 0.5, {rotationX: 90, transformOrigin: "50% 50%"}, {rotationX: 0, transformOrigin: "50% 50%", ease: Back.easeOut}, 0.25);

                var timelinePC = new TimelineMax();

                timelinePC
                        .add(tweenPC1)
                        .add(tweenPC2)
                        .add(tweenPC3);

                var scene = new ScrollMagic.Scene({triggerElement: "#gestiondepacientes"})
                        .setTween(timelinePC)
                        //.addIndicators()
                        .reverse(false)
                        .addTo(controller);



                //---
            }









            if ($('.hom-servicios-list-menu').length > 0) {

                var servicio = $('.hom-servicios-list-menu').find('li').children('a');

                servicio.on('click', function (e) {
                    e.preventDefault();

                    if (typeof $(this).data('srv') !== 'undefined') {
                        var lnkTo = "#" + $(this).data('srv');
                        mulScroll($(lnkTo));
                    }

                });

            }

        });
    </script>
{/literal}