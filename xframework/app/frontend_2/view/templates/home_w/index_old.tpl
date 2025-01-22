<style>
    @media (max-width: 1040px) {
        .hin-doctorplus-rsp-logo-lg {
            display:none !important;
        }
    }
    .hin-doctorplus-rsp-logo-lg {
        display: inline-block;
        float: left;
        text-align: right;
        padding-top: 10px;
        padding-left: 16px;
        position: relative;
    }
    #hom-nav-rsp-get .btn-login, #hom-nav-rsp-get .btn-signup{
        border: solid 1px;
        border-radius: 5px;
        border-color: white;
        padding: 5px 10px;
        background: #ffa912;
    } 
    @media (min-width: 800px){
        .pos1{ 
            background-color: rgba(255,255,255,.6);
        }
    }
    .pos1{
        width: 800px!important;
        max-width: 800px!important;
        padding: 20px!important;
        font-size: 12px!important;
    }
    .home-francia .hin-slide-data-box h1.hin-portada-title {
        margin-bottom: 20px!important;
    }
    @media (max-width: 600px) { 
        .hin-portada-title {
            font-size: 20px !important;
        }
    }

    @media (max-width: 600px) {
        #buscar_profesionales{
            margin:auto;
            width: 100%;
        }
    }
    @media (min-width: 600px) {
        #buscar_profesionales{
            margin:auto;
            width: 80%;
        }
    }
    #pais_idpais{
        display:none;
    }

    .home-francia .formulario-busqueda .input-group {
        width: 80%;
        margin: auto;
    }
    .buscar-xs .btnBuscarProfesionales {
        width: 50%;
        margin-top: 20px;
    }
    @media (max-width:600px){
        .home-francia .formulario-busqueda .input-group {
            width: 100%;
            margin: auto;
        }
        .select-group.especialidad{
            position: relative;
            width: 100%;
        }

        .select-group.pais{
            position: relative;
            width: 100%;
            float: right;
            margin-top: 10px;
        }
    }
    @media (min-width:600px){
        .select-group.especialidad{
            position: relative;
            /*width: 65%;*/
            width:100%;
        }

        .select-group.pais{
            position: relative;
            width: 35%;
            float: right;
        }
    }
    @media (max-width:960px){
        .hin-doctorplus-rsp-logo {
            display: inline-block;
            position: absolute;
            top: 50%;
            left: 50%;
            bottom: auto;
            transform: translate(-50%,-50%);
            padding-top: 4px;
            margin-left: 0;
        }
    }
</style>
{include file="home/login.tpl"}


<nav class="hom-nav">
    <div class="okm-container">

        <div class="okm-row">
            <div class="hin-doctorplus-rsp-logo-lg hidden-xs">
                <a data-lnk="hom-DoctorPlus" href="{$url}"><img src="{$IMGS}doctorplus_logo_mobile.png" title="Doctor Plus"></a>
            </div>
            <div class="hin-doctorplus-rsp-logo">
                <a href="javascript:;"><img src="{$IMGS}doctorplus_logo_mobile.png" title="Doctor Plus"></a>
            </div>
            <div class="hom-nav-menu">
                <a href="javascript:;" id="hom-nav-rsp-trg" class="hom-nav-burger"><i class="icon-doctorplus-burger"></i></a>
                <ul id="hom-nav-rsp-get">
                    <li class="visible-xs visible-sm"><a href="JavaScript:void(0)" id="loginbtn2" title='{"Iniciar sesión"|x_translate}'><strong>{"Iniciar sesión"|x_translate}</strong></a></li>
                    <li class="visible-xs visible-sm"><a href="{$url}creer-un-compte.html" title='{"Crear una cuenta"|x_translate}'><strong>{"Crear una cuenta"|x_translate}</strong></a></li>  
                    <li><a href="{$url}creer-compte.html"  title='{"Pase de Salud"|x_translate}'><strong>{"Pase de Salud"|x_translate}</strong></a></li>
                    <li><a data-lnk="hom-utilizacion" href="javascript:;"  title='{"Utilizacion"|x_translate}'>{"Utilizacion"|x_translate}</a></li>
                    <li><a data-lnk="hom-motivos" href="javascript:;" title='{"Motivos de consulta"|x_translate}' >{"Motivos de consulta"|x_translate}</a></li>
                    <li><a data-lnk="hom-experiencia" href="javascript:;" title='{"Una experiencia única"|x_translate}' >{"Una experiencia única"|x_translate}</a></li>
                    <li><a data-lnk="hom-medicos" href="javascript:;" title='{"Los médicos"|x_translate}' >{"Los médicos"|x_translate}</a></li>
                    <li><a data-lnk="hom-contacto" href="javascript:;" title='{"Contacto"|x_translate}' >{"Contacto"|x_translate}</a></li>
                    <li class="hidden-xs hidden-sm">
                        <a href="{$url}creer-un-compte.html" class="btn-signup" title='{"Crear una cuenta"|x_translate}' >{"Crear una cuenta"|x_translate}</a>
                    </li>
                    <li class="hidden-xs hidden-sm">
                        <a href="JavaScript:void(0)" id="loginbtn" class="btn-login" title='{"Iniciar sesión"|x_translate}'>{"Iniciar sesión"|x_translate}</a>
                    </li>
                </ul>
            </div>
        </div>
    </div>
</nav>

<div class="hp-home-wrapper hom-DoctorPlus" id="hom-DoctorPlus">
    <section class="hp-home home-francia" id="pass_sante_masonry">

        {include file="programa_salud/grid_programas.tpl"}

    </section>

    <section class="hin-solucion-integral">
        <a href="{$url}medecin-ou-professionnel/">
            <div class="hin-solucion-integral-box">

                <h2>
                    {"¿Eres practicante?"|x_translate}
                </h2>

                {*<h3>{"Descubra nuestra solución de teleconsulta con acceso gratuito y sin compromiso."|x_translate} <br>
                {"¡Regístrese en línea con unos pocos clics y comience de inmediato!"|x_translate} 
                </h3>
                <h3><strong>{"Ahorre tiempo médico ahora."|x_translate}</strong> </h3>
                *}
                <span>{"Saber más"|x_translate}</span>

            </div>
        </a>
    </section>
    {include file="home/banner_pass_esante.tpl"}

    <div id="hom-utilizacion"></div>
    <section class="hin-soluciones" id="soluciones">
        <div class="hin-soluciones-box">
            <h2 id="hom-quehacer">
                {"¿Por qué usar DoctorPlus?"|x_translate}
            </h2>

            <div class="hin-soluciones-sub">
                <p  style="opacity:0" class="anim-text-soluciones">
                    <i class="icon-doctorplus-check-thin"></i>
                    {"Pedir cita. Reciba consejos de su médico u otro profesional a través de una Consulta Express por mensajería segura"|x_translate}

                </p>
                <p style="opacity:0" class="anim-text-soluciones">
                    <i class="icon-doctorplus-check-thin"></i>
                    {"Haga una consulta en video con su médico para que no tenga que ir a la oficina. También se benefician de un soporte bajo condiciones"|x_translate}
                </p>
            </div>
            <div class="text-center"><br>
                <a href="{$url}patient/creer-un-compte.html" class="btn btn-blue">{"Crear una cuenta"|x_translate}</a>
            </div>
        </div>

        <div class="container hin-servicios" id="servicios">
            <div class="okm-row">
                <div class="hin-servicios-col">

                    <div class="hin-servicio-row">
                        <div class="hin-servicio-title">
                            <figure class="hin-servicio-icon red anim-bubble">
                                <i class="icon-doctorplus-video-call"></i>		
                            </figure>
                            <h4>{"Video Consulta"|x_translate}</h4>
                        </div>
                        <div class="hin-servicio-content">
                            <p>
                                {"Consulte a su médico de cabecera y hable con él como lo haría en el consultorio. En el 80% de los casos, esto debería ser suficiente para una opinión médica o una consulta de seguimiento"|x_translate}
                            </p>
                        </div>
                    </div>

                    <div class="hin-servicio-row">
                        <div class="hin-servicio-title">
                            <figure class="hin-servicio-icon segundo red anim-bubble">
                                <i class="icon-doctorplus-pharmaceutics"></i>	
                            </figure>
                            <h4>{"Perfil de salud e historial de consultas"|x_translate}</h4>
                        </div>
                        <div class="hin-servicio-content">
                            <p>
                                {"Centralice su información de salud y manténgala siempre a mano"|x_translate}
                            </p>
                        </div>
                    </div>

                    <div class="hin-servicio-row">
                        <div class="hin-servicio-title-block">
                            <figure class="hin-servicio-icon red anim-bubble">
                                <i class="icon-doctorplus-calendar"></i>	
                            </figure>
                            <figure class="hin-servicio-icon red anim-bubble">
                                <i class="icon-doctorplus-search"></i>		
                            </figure>
                            <h4>{"Haga una cita, invite a su médico."|x_translate}</h4>
                        </div>
                        <div class="hin-servicio-content">
                            <p>
                                {"Invita a tu médico y a los profesionales de la salud que conoces. De lo contrario, encuentre en unos pocos clics los profesionales disponibles"|x_translate}
                            </p>
                        </div>
                    </div>



                </div>
                <div class="hin-servicios-mobile-col">
                    <div class="hin-servicios-mobile-image-box anim-image-servicios">
                        <img src="{$IMGS}home/doctor-plus-mobile.png"  title='{"Doctor Plus servicios"|x_translate}'/>
                    </div>
                </div>
                <div class="hin-servicios-col">

                    <div class="hin-servicio-row">
                        <div class="hin-servicio-title">
                            <figure class="hin-servicio-icon red anim-bubble-6">
                                <i class="icon-doctorplus-chat"></i>					
                            </figure>
                            <h4>{"Aviso y consejos"|x_translate}</h4>
                        </div>
                        <div class="hin-servicio-content">
                            <p>
                                {"Tu doctor también está ocupado. Más dinámico que un correo electrónico ... y mucho menos intrusivo que la mensajería instantánea"|x_translate}
                            </p>
                        </div>
                    </div>

                    <div class="hin-servicio-row">
                        <div class="hin-servicio-title no-content">
                            <figure class="hin-servicio-icon segundo red anim-bubble-7">
                                <i class="icon-doctorplus-flag"></i>						
                            </figure>
                            <h4>{"Notificaciones y controles"|x_translate}</h4>
                        </div>
                        <div class="hin-servicio-content">
                            <p>
                                {"Tu libro de salud conectado. Reciba recordatorios de citas, cheques y alertas automáticas de vacunación"|x_translate}
                            </p>
                        </div>
                    </div>

                    <div class="hin-servicio-row">
                        <div class="hin-servicio-title-block">
                            <figure class="hin-servicio-icon green anim-bubble-8">
                                <i class="icon-doctorplus-pills"></i>		
                            </figure>
                            <figure class="hin-servicio-icon green anim-bubble-8">
                                <i class="icon-doctorplus-share"></i>		
                            </figure>
                            <span class="hin-ymas">{"Y mucho mas!"|x_translate}</span>
                        </div>
                        <div class="hin-servicio-content no-title">
                            <p>
                                {"Envíe a su médico una solicitud de renovación de receta o recíbala después de una consulta por video si su médico lo considera necesario"|x_translate}
                            </p>
                        </div>
                    </div>
                </div>

            </div>
        </div>
    </section>




    <section class="hin-solucion-integral" >
        <div class="hin-solucion-integral-box">
            <h2>
                {"DoctorPlus no debe usarse para tratar afecciones médicas que impliquen el diagnóstico vital del paciente o en emergencias y otros casos que puedan conducir a un rápido deterioro de la condición del paciente."|x_translate}
            </h2>
            <h3>
                {"El uso de la telemedicina se recomienda para afecciones diarias frecuentes, consejos y opiniones relacionadas con la salud y los tratamientos actuales, el seguimiento de los pacientes después de la consulta en el consultorio, especialmente para las patologías crónicas."|x_translate}
            </h3>
        </div>
    </section>
    <div id="hom-motivos"></div>
    <section class="hin-soluciones  home-francia" id="comparativo">
        <div class="hin-soluciones-box">

            <div class="col-comparativo anim-text-comparativo" style="opacity:0">
                <h2 class="red">
                    {"Motivos de consulta"|x_translate}
                    <span class="bold">
                        {"NO tratados"|x_translate}
                    </span>
                    <i class="fa fa-chevron-down flecha animatedColor"></i>
                </h2>
                <ul style="display:none">
                    <li>{"Despues de un accidente"|x_translate}</li>
                    <li>{"Después de una electrocución"|x_translate}</li>
                    <li>{"Quemaduras moderadas o significativas"|x_translate}</li>
                    <li>{"Diagnóstico complejo"|x_translate}</li>
                    <li>{"Envenenamiento, intoxicación"|x_translate}</li>
                    <li>{"Entumecimiento, parálisis repentina"|x_translate}</li>
                    <li>{"Dolor severo en el pecho o brazo izquierdo"|x_translate}</li>
                    <li>{"fractura abierta"|x_translate}</li>
                    <li>{"Hemorragia o sangrado abundante"|x_translate}</li>
                    <li>{"Inflamación pulmonar"|x_translate}</li>
                    <li>{"Lesiones graves en la cabeza, el cuello o la espalda"|x_translate}</li>
                    <li>{"Pérdida significativa de líquidos"|x_translate}</li>
                    <li>{"Pérdida o alteración de la conciencia"|x_translate}</li>
                    <li>{"Problemas cardíacos"|x_translate}</li>
                    <li>{"Emergencia médica, amenaza de vida"|x_translate}</li>
                    <li>{"Vómitos incesantes"|x_translate}</li>
                </ul>      
            </div>
            <div class="col-comparativo  anim-text-comparativo" style="opacity:0; float:right; margin-right:0px">
                <h2 class="green">
                    {"Motivos de consulta"|x_translate}
                    <span class="bold"> {"tratados"|x_translate}</span>
                    <i class="fa fa-chevron-down flecha animatedColor"></i>
                </h2>
                <ul style="display:none">
                    <li>{"Actividad deportiva"|x_translate}</li>
                    <li>{"Adicciones"|x_translate}</li>
                    <li>{"Condiciones crónicas"|x_translate}</li>
                    <li>{"Bienestar"|x_translate}</li>
                    <li>{"Consultas medicas"|x_translate}</li>
                    <li>{"Desarrollo personal"|x_translate}</li>
                    <li>{"Dificultades de la vida"|x_translate}</li>
                    <li>{"Nutrición dietética"|x_translate}</li>
                    <li>{"Dolor"|x_translate}</li>
                    <li>{"Todo para la familia"|x_translate}</li>
                    <li>{"Futuras madres jóvenes"|x_translate}</li>
                    <li>{"Salud alternativa"|x_translate}</li>
                    <li>{"Cuidado"|x_translate}</li>
                    <li>{"Trastornos del sueño"|x_translate}</li>
                    <li>{"Viajes"|x_translate}</li>
                    <li>{"Vida íntima"|x_translate}</li>

                </ul>
            </div>
            <div class="clearfix"></div>
        </div>
        <div class="clearfix"></div>  



    </section>
    <div class="clearfix"></div>
    <div id="hom-experiencia"></div>
    <section class="hin-beneficios" id="beneficios">
        <h2>{"Una experiencia única"|x_translate}</h2>
        <div class="hin-beneficios-box">
            <img class="hin-img-rsp-swap hin-beneficios-image" src="{$IMGS}home/beneficios-home-wide.jpg"  data-altimg-1200="{$IMGS}home/beneficios-home.jpg" data-altimg-big="{$IMGS}home/beneficios-home-wide.jpg" title='{"Beneficios"|x_translate}'/>
            <div class="hin-beneficios-content">
                <div class="container hin-beneficios-list">
                    <div class="okm-row">

                        <div class="hin-beneficios-col anim-beneficios">
                            <div class="hin-beneficios-icon">
                                <img src="{$IMGS}home/marco-legal-icon.png"  title='{"Marco legal y seguro"|x_translate}'/>
                            </div>
                            <h4>{"Marco legal y seguro"|x_translate}</h4>
                            <p>
                                {"Consultas e info de salud bajo estrictas normas de confidencialidad y protección de datos."|x_translate}
                            </p>
                        </div>

                        <div class="hin-beneficios-col anim-beneficios">
                            <div class="hin-beneficios-icon">
                                <img src="{$IMGS}home/atencion-calificada-icon.png"  title='{"Atención calificada"|x_translate}'/>
                            </div>
                            <h4>{"Atención calificada"|x_translate}</h4>
                            <p>
                                {"Se evita la búsqueda de consejos por internet o robots de respuestas automáticas para solucionar cuestiones de salud."|x_translate}
                            </p>
                        </div>

                        <div class="hin-beneficios-col anim-beneficios">
                            <div class="hin-beneficios-icon">
                                <img src="{$IMGS}home/abono-consultas-icon.png"  title='{"Abonas solo cuando consultas"|x_translate}'/>
                            </div>
                            <h4>{"Abonas solo cuando consultas"|x_translate}</h4>
                            <p>
                                {"Una cuenta de uso gratuito y sin costos fijos. Abonas solo cuando consultas. Cada profesional publica su tarifa."|x_translate}
                            </p>
                        </div>

                        <div class="hin-beneficios-col anim-beneficios">
                            <div class="hin-beneficios-icon">
                                <img src="{$IMGS}home/prevencion.png"  title='{"Prevención"|x_translate}'/>
                            </div>
                            <h4>{"Prevención"|x_translate}</h4>
                            <p>
                                {"La salud es algo que no puede esperar. No más horas de espera en una guardia ni turnos con alta demora de atención."|x_translate}
                            </p>
                        </div>

                    </div>

                </div>
            </div>
        </div>

    </section>
    <div id="hom-medicos"></div>
    <section class="hin-profesionales" id="profesionales-de-la-red">
        <h2 id="hom-profesionales" class="hin-profesionales-title profesionales-anim-trg">{"Encuentre a sus médicos y otros profesionales de la salud en DoctorPlus"|x_translate}</h2>
        <img class="hin-profesionales-img" src="{$IMGS}home/profesionales-de-la-red.jpg"  title='{"Profesionales de la red"|x_translate}'/>

        <div class="hin-profesionales-content">

            <div class="hin-profesionales-banner">
                <p class="anim-profesionale-text">
                    {"Consulte con confianza. Los médicos y profesionales de la salud registrados en DoctorPlus estaban sujetos a una verificación antes de su registro."|x_translate}
                </p>
            </div>
        </div>
    </section>	

</div>



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


            $(':checkbox').radiocheck();
            $(':radio').radiocheck();
            function mulScroll(trgObj) {
                var trgObjHeight = trgObj.outerHeight();
                $('html, body').animate({
                    scrollTop: (trgObj.offset().top - trgObjHeight) - 60
                }, 1000);
            }

            $(".btnBuscarProfesionales").click(function (e) {
                e.preventDefault();
                if ($("#especialidad_ti").val() == "") {
                    x_alert(x_translate("Seleccione al menos una especialidad"));
                    return false;
                }
                if ($("#pais_idpais").val() == "") {
                    x_alert(x_translate("Seleccione al menos un país"));
                    return false;
                }

                console.log("buscar", $("#buscar_profesionales").serialize());
                window.location.href = BASE_PATH + "recherche-medecin/?" + $("#buscar_profesionales").serialize();
            });

            if ($('.js-rsp').length > 0) {
                enquire.register("screen and (max-width:1200px)", {

                    match: function () {
                        // medico home img swap
                        imgSrc = $('#hin-img-rsp-swap').data('altimg-1200');
                        $('#hin-img-rsp-swap').attr('src', imgSrc);

                    },

                    unmatch: function () {
                        // medico home img swap
                        imgSrc = $('#hin-img-rsp-swap').data('altimg-big');
                        $('#hin-img-rsp-swap').attr('src', imgSrc);
                    }
                });
            }
            //seleccionar tipo usuario
            $("#btnSelectUsuario").click(function () {
                if ($("#paciente").is(":checked")) {
                    window.location.href = BASE_PATH + "paciente/";
                }
                if ($("#profesional").is(":checked")) {
                    window.location.href = BASE_PATH + "profesional/";
                }
            });

            //mostrar modal de login
            $('#loginbtn,#loginbtn2, #loginbtn3').on('click', function (e) {
                e.preventDefault();
                $('.usrlogin').modal('toggle');
            });

            $('#hom-nav-rsp-trg').on('click', function (e) {


                $('#hom-nav-rsp-get').toggleClass('menu-show');

            });
            $(document).on('click', function (event) {
                if ((!$(event.target).closest('#hom-nav-rsp-trg').length)) {
                    $('#hom-nav-rsp-get').removeClass('menu-show');
                }
            });

            $(window).on('scroll', function () {
                var currentTop = $(window).scrollTop();

                if (currentTop >= 60) {
                    $('.hom-nav').addClass('transparent');
                } else if (currentTop < 60) {
                    $('.hom-nav').removeClass('transparent');
                }

            });

            $("#comparativo h2").click(function () {
                $(this).siblings().slideToggle();
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



            // init controller
            var controller = new ScrollMagic.Controller();

            // textos soluciones
            var tweenTextSoluciones = TweenMax.staggerTo(".anim-text-soluciones", 1, {opacity: 1}, 0.5);

            // textos Comparativo
            var tweenTextComparativo = TweenMax.staggerTo(".anim-text-comparativo", 1, {opacity: 1}, 0.5);


            var scene = new ScrollMagic.Scene({triggerElement: "#soluciones"})
                    .setTween(tweenTextSoluciones)
                    //.addIndicators() 
                    .reverse(false)
                    .addTo(controller);


            var scene2 = new ScrollMagic.Scene({triggerElement: "#comparativo"})
                    .setTween(tweenTextComparativo)
                    //.addIndicators() 
                    .reverse(false)
                    .addTo(controller);

            // textos tweenServicios

            var timelineServicios = new TimelineMax();

            var tweenImgServicios = TweenMax.staggerFromTo(".anim-image-servicios", 1, {rotationY: 90, transformOrigin: "50% 50%"}, {rotationY: 0, transformOrigin: "50% 50%", ease: Back.easeOut}, 0.15);

            timelineServicios
                    .add(tweenImgServicios)


            var scene = new ScrollMagic.Scene({triggerElement: "#servicios"})
                    .setTween(timelineServicios)
                    //.addIndicators()
                    .reverse(false)
                    .addTo(controller);


            var timelineServicios = new TimelineMax();

            var tweenServicios = TweenMax.staggerFromTo(".anim-bubble", 0.5, {scale: 0}, {scale: 1, ease: Back.easeOut}, 0.2)
            var tweenServicios6 = TweenMax.staggerFromTo(".anim-bubble-6", 0.1, {scale: 0}, {scale: 1, ease: Back.easeOut}, 0.2)
            var tweenServicios7 = TweenMax.staggerFromTo(".anim-bubble-7", 0.3, {scale: 0}, {scale: 1, ease: Back.easeOut}, 0.2)
            var tweenServicios8 = TweenMax.staggerFromTo(".anim-bubble-8", 0.3, {scale: 0}, {scale: 1, ease: Back.easeOut}, 0)

            timelineServicios
                    .add(tweenServicios)
                    .add(tweenServicios6)
                    .add(tweenServicios7)
                    .add(tweenServicios8);


            var scene = new ScrollMagic.Scene({triggerElement: "#servicios"})
                    .setTween(timelineServicios)
                    //.addIndicators()
                    .reverse(false)
                    .addTo(controller);


            // textos soluciones
            var tweenBeneficiosBack = TweenMax.staggerFromTo(".hin-beneficios-content", 0.5, {opacity: 0}, {opacity: 1, ease: Back.easeOut}, 0);
            var tweenBeneficios = TweenMax.staggerFromTo(".anim-beneficios", 0.5, {opacity: 0, top: 100}, {opacity: 1, top: 0, ease: Back.easeOut}, 0.2);

            var timelineBeneficios = new TimelineMax();

            timelineBeneficios
                    .add(tweenBeneficiosBack)
                    .add(tweenBeneficios);

            var scene = new ScrollMagic.Scene({triggerElement: "#beneficios"})
                    .setTween(timelineBeneficios)
                    //.addIndicators()
                    .reverse(false)
                    .addTo(controller);


            var tweenProfesionales = TweenMax.staggerFromTo(".anim-profesionale-text", 1, {opacity: 0, left: -200}, {opacity: 1, left: 0, ease: Back.easeOut}, 0.5);

            var scene = new ScrollMagic.Scene({triggerElement: ".profesionales-anim-trg"})
                    .setTween(tweenProfesionales)
                    //.addIndicators()
                    .reverse(false)
                    .addTo(controller);


            var tweenQSText = TweenMax.staggerFromTo(".anim-txt-qs", 1, {opacity: 0, top: -200}, {opacity: 1, top: 0, ease: Back.easeOut}, 0.5);

            var scene = new ScrollMagic.Scene({triggerElement: ".hp-quines-somos"})
                    .setTween(tweenQSText)
                    //.addIndicators()
                    .reverse(false)
                    .addTo(controller);


            var tweenImgQS = TweenMax.staggerFromTo(".anim-qs-img", 1, {rotationY: 90, transformOrigin: "50% 50%"}, {rotationY: 0, transformOrigin: "50% 50%", ease: Back.easeOut}, 0.15);

            var scene = new ScrollMagic.Scene({triggerElement: ".anim-qs-img-trg"})
                    .setTween(tweenImgQS)
                    //.addIndicators()
                    .reverse(false)
                    .addTo(controller);


        });
    </script>
{/literal}

{if $timeout_modal=="1"}
    {literal}
        <script>
            $(function () {

                $('#timeout-trigger').click();
                $('#modal_login').on('hidden.bs.modal', function () {
                    x_doAjaxCall(
                            'POST',
                            BASE_PATH + "clear_user.do",
                            '',
                            function () {});
                });





            });
        </script>
    {/literal}
{/if}