<link rel="stylesheet" href="{$url_themes}css/guiadeuso.css">

<section class="section-header section-header profile filter-table-header filter-table-header-paciente">
    <div class="container">
        <div class="user-select pull-left">
            <i class="icon-doctorplus-info-circle"></i> 
            <h1 class="section-name">{"Preguntas frecuentes"|x_translate}</h1>
        </div>
    </div>
</section> 

<section class="guia-de-uso">


    <article>
        <a href="javascript:;" class="gdu-action-box">
            <h3>{"Tipos de consultas a distancia"|x_translate}</h3>
        </a>
        <div class="okm-container tipo-consulta-express-video gdu-content">
            <div class="okm-row">
                <div class="tipo-consulta-video-col">
                    <div class="tipo-consulta-video-item">
                        <h4>{"Video Consulta"|x_translate}</h4>
                        <figure>
                            <img src="{$IMGS}paciente/guia/tipo-video-consulta-guia.png" alt="Video Consulta"/>
                        </figure>
                    </div>
                </div>
                <div class="tipo-consulta-express-col">
                    <div class="tipo-consulta-video-item">
                        <h4>{"Consulta Express"|x_translate}</h4>
                        <figure>
                            <img src="{$IMGS}paciente/guia/tipo-consulta-express-guia.png" alt="Consulta Express"/>
                        </figure>
                    </div>
                </div>
            </div>

            <div class="okm-row tipo-consulta-express-video-footer">
                <h5>{"Puedes enviar tu consulta a un profesional en particular o a varios simultáneamente publicando a traves de Profesionales en la Red."|x_translate}</h5>
                <p class="higlight">{"Te atenderá el primer profesional disponible minimizando tu tiempo de espera."|x_translate}</p>
                <p>{"Consulta con tranquilidad. Todos los profesionales que ofrecen sus servicios a través de DoctorPlus han sido validados por el Ministerio de Salud y los Colegios Médicos correspondientes."|x_translate}</p>
            </div>
        </div>
    </article>

    <article>
        <a href="javascript:;" class="gdu-action-box">
            <h3>{"¿Cómo solicitar una Video Consulta?"|x_translate}</h3>
        </a>
        <div class="okm-container tipo-consulta-video-consulta gdu-content">

            <div class="okm-row">

                <div class="video-consultas-pasos-col video-consultas-paso-1">
                    <figure><img src="{$IMGS}paciente/guia/paso-1.png"></figure>
                    <div class="video-consultas-pasos-number">
                        <span>1</span>
                        <i class="icon-doctorplus-ficha-tecnica"></i>
                    </div>
                    <p class="video-consultas-pasos-txt">
                        {"Ingresa a Video Consulta y haz click en Nueva Consulta."|x_translate}
                    </p>
                </div>


                <div class="video-consultas-pasos-col video-consultas-paso-2">
                    <figure><img src="{$IMGS}paciente/guia/paso-2.png"></figure>
                    <div class="video-consultas-pasos-number">
                        <span>2</span>
                        <i class="icon-doctorplus-map-point"></i>
                    </div>
                    <p class="video-consultas-pasos-txt">
                        {"Busca un especialista según tus preferencias (valor de tarifa, valoración de usuarios, etc) Puedes enviar tu consulta a uno o varios en forma simultánea a traves de Profesionales en la Red."|x_translate} </p>
                </div>


                <div class="video-consultas-pasos-col video-consultas-paso-3">
                    <figure><img src="{$IMGS}paciente/guia/paso-3.png"></figure>
                    <div class="video-consultas-pasos-number">
                        <span>3</span>
                        <i class="icon-doctorplus-dollar-circular"></i>
                        <i class="icon-doctorplus-dollar-add"></i>
                    </div>
                    <p class="video-consultas-pasos-txt">
                        {"Confirma el pago o carga crédito para poder abonar la consulta. Recuerda que hasta que no te atiendan puedes cancelar la consulta y el dinero será reembolsado a tu cuenta."|x_translate}
                    </p>
                </div>

                <div class="video-consultas-pasos-col video-consultas-paso-4">
                    <figure><img src="{$IMGS}paciente/guia/paso-4.png"></figure>
                    <div class="video-consultas-pasos-number">
                        <span>4</span>
                        <i class="icon-doctorplus-calendar-time"></i>
                    </div>
                    <p class="video-consultas-pasos-txt">
                        {"Selecciona el motivo de tu consulta y aguarda a que un profesional te confirme por SMS o mailel horario en que te atenderá."|x_translate}
                    </p>

                </div>

            </div>


            <div class="okm-row">
                <div class="video-consultas-pasos-col-center">

                    <figure>
                        <img src="{$IMGS}video-consulta/video-mobile.png">
                    </figure>
                    <p>
                        {"A la hora acordada entra a la Sala del Consultorio Virtual y espera a que el médico te llame para iniciar la Video Consulta"|x_translate}</p>
                </div>
            </div>

            <div class="okm-row">

                <div class="video-consultas-features-row">

                    <div class="video-consultas-features-col">
                        <figure>
                            <img src="{$IMGS}video-consulta/imagenes.png"/>
                        </figure>
                        <h5>{"Posibilidad de incluir imágenes"|x_translate}</h5>
                        <p>
                            {"Además... tenés la posibilidad de compartir imágenes y  documentos con el profesional durante tu consulta. Las mismas quedarán almacenadas en tu historial de Estudios e imágenes para, por ejemplo, poder ser compartidas con otros profesionales."|x_translate}
                        </p>
                    </div>

                    <div class="video-consultas-features-col">
                        <figure>
                            <img src="{$IMGS}video-consulta/hostorial.png"/>
                        </figure>
                        <h5>{"Historial de Registros Médicos"|x_translate}</h5>
                        <p>
                            {"Al finalizar la consulta el médico te enviará sus conclusiones, tratamiento  o diagnóstico por mial. También quedará almacenado en tu Historial de Registros Médicos del Perfil de Salud."|x_translate}
                        </p>
                    </div>

                    <div class="video-consultas-features-col">
                        <figure>
                            <img src="{$IMGS}video-consulta/cancelacion.png"/>
                        </figure>
                        <h5>{"Devolución en caso de cancelación"|x_translate}</h5>
                        <p>
                            {"Si tu consulta no fue atendida en el plazo establecido, deseas cancelarla o el médico considera que no puede resolver tu consulta por este medio, el importe de la misma será reintegrado en tu cuenta."|x_translate}
                        </p>
                    </div>
                </div>
            </div>


        </div>
    </article>

    <article>
        <a href="javascript:;" class="gdu-action-box">
            <h3>{"¿Cómo enviar una Consulta Express?"|x_translate}</h3>
        </a>
        <div class="okm-container tipo-consulta-video-consulta tipo-consulta-consulta-express gdu-content">

            <div class="okm-row">

                <div class="video-consultas-pasos-col video-consultas-paso-2">
                    <figure><img src="{$IMGS}paciente/guia/paso-2.png"></figure>
                    <div class="video-consultas-pasos-number">
                        <span>1</span>
                        <i class="icon-doctorplus-map-point"></i>
                    </div>
                    <p class="video-consultas-pasos-txt">
                        {"Ingresa a Consulta Express y selecciona a uno o varios profesionales de la misma especialidad."|x_translate}</p>
                </div>


                <div class="video-consultas-pasos-col video-consultas-paso-3">
                    <figure><img src="{$IMGS}paciente/guia/paso-3.png"></figure>
                    <div class="video-consultas-pasos-number">
                        <span>2</span>
                        <i class="icon-doctorplus-dollar-circular"></i>
                        <i class="icon-doctorplus-dollar-add"></i>
                    </div>
                    <p class="video-consultas-pasos-txt">
                        {"Confirma el pago o cargá crédito para poder realizar la consulta"|x_translate}</p>
                </div>

                <div class="video-consultas-pasos-col video-consultas-paso-4">
                    <figure><img src="{$IMGS}paciente/guia/paso-4.png"></figure>
                    <div class="video-consultas-pasos-number">
                        <span>3</span>
                        <i class="icon-doctorplus-calendar-time"></i>
                    </div>
                    <p class="video-consultas-pasos-txt">
                        {"Escribe y envía tu consulta. Si deseas puedes adjuntar una foto. Aguarda la respuesta."|x_translate}
                        </small>
                    </p>

                </div>

            </div>

            <div class="okm-row">

            </div>


            <div class="okm-row">

                <div class="video-consultas-features-row">

                    <div class="video-consultas-features-col">
                        <figure>
                            <img src="{$IMGS}video-consulta/imagenes.png">
                        </figure>
                        <h5>{"Posibilidad de incluir imágenes"|x_translate}</h5>
                        <p>
                            {"Tienes la posibilidad de compartir imágenes y documentos con el profesional durante tu consulta. Las mismas quedarán almacenadas en tu historial de Estudios e imágenes."|x_translate}</p>
                    </div>

                    <div class="video-consultas-features-col">
                        <figure>
                            <img src="{$IMGS}video-consulta/hostorial.png">
                        </figure>
                        <h5>{"Historial de Registros Médicos"|x_translate}</h5>
                        <p>
                            {"Al finalizar la consulta el médico te enviará sus conclusiones, tratamiento  o diagnóstico por mial. También quedará almacenado en tu Historial de Registros Médicos del Perfil de Salud."|x_translate}
                        </p>
                    </div>

                    <div class="video-consultas-features-col">
                        <figure>
                            <img src="{$IMGS}video-consulta/cancelacion.png">
                        </figure>
                        <h5>{"Devolución en caso de cancelación"|x_translate}</h5>
                        <p>
                            {"Si tu consulta no fue atendida en el plazo establecido o deseas cancelarla,  el importe de la misma será reintegrado en tu cuenta."|x_translate}</p>
                    </div>

                </div>

            </div>


        </div>
    </article>


    <article>
        <a href="javascript:;" class="gdu-action-box">
            <h3>{"Pasos para sacar un turno en consultorio"|x_translate}</h3>
        </a>
        <div class="okm-container tipo-consulta-consultorio gdu-content">


            <div class="okm-row">
                <div class="pbr-instrucciones-col">
                    <i class="icon-doctorplus-map-point pbr-icon-1"></i>
                    <p>{"Busca un profesional según tus preferencias (zona, valor de la tarifa, referencias académicas, etc.)"|x_translate}
                    </p>
                    <figure>
                        <img src="{$IMGS}pbr/pbr-img-1.png" alt="Buscá médicos">
                    </figure>
                </div>
                <div class="pbr-instrucciones-col">
                    <i class="icon-doctorplus-24 pbr-icon-2"></i>
                    <p>{"Consulta su disponibilidad"|x_translate}</p>
                    <figure>
                        <img src="{$IMGS}pbr/pbr-img-2.png" alt="Consultá">
                    </figure>
                </div>
                <div class="pbr-instrucciones-col">
                    <i class="icon-doctorplus-calendar-time pbr-icon-3"></i>
                    <p>{"Reserva un turno. Te enviaremos por mail la confirmación y recordatorios días previos a la cita."|x_translate}</p>
                    <figure>
                        <img src="{$IMGS}pbr/pbr-img-3.png" alt="Reservá">
                    </figure>
                </div>
            </div>


            <div class="okm-row tipo-consulta-consultorio-footer">
                <p>{"Consulta con tranquilidad. Todos los profesionales que ofrecen sus servicios a través de DoctorPlus han sido validados por el Ministerio de Salud y los Colegios Médicos correspondientes. La calificación de otros usuarios te ayudará a evaluar el servicio brindado por ese especialista."|x_translate}</p>
            </div>
        </div>
    </article>
    <article>
        <a href="javascript:;" class="gdu-action-box" data-masonry="true">
            <h3>{"Cómo funciona la Video Consulta?"|x_translate}</h3>
        </a>
        <div class="okm-container gdu-content init-masonty">
            <div class="okm-row">

                <div class="mvc-guia-grid">
                    <div class="mvc-grid-sizer"></div>
                    <div class="mvc-grid-gutter"></div>

                    <div class="mvc-guia-item mvc-grid-item-1 bg-type-1">
                        <a href="#" class="mvc-guia-holder-trg">{"¿Cuándo comienza la Video Consulta?"|x_translate}</a>
                        <div class="mvc-guia-holder">
                            <small class="mvc-bread">{"Video Consulta"|x_translate}</small>	
                            <h4 class="mvc-grid-title-1">{"¿Cuándo comienza la Video Consulta?"|x_translate}</h4>
                            <p class="mvc-grid-p item-p-spacer">
                                {"Cuando ingresa a la Sala ud. debe esperar a ser llamado por el profesional"|x_translate}
                            </p>
                            <ul class="mvc-grid-icon-list">
                                <li>
                                    <figure><i class="icon-doctorplus-check-thin"></i></figure>
                                    <p>{"Quiere decir que está en línea y puede llamarlo."|x_translate}</p>
                                </li>
                                <li>
                                    <figure class="yellow"><i class="icon-doctorplus-minus"></i></figure>
                                    <p>
                                        {"Quiere decir que no está aún disponible o está terminando de atender a otro paciente. Aguarde a ser llamado."|x_translate}
                                    </p>
                                </li>
                            </ul>
                        </div>
                    </div>

                    <div class="mvc-guia-item mvc-grid-item-10 bg-type-3">
                        <a href="#" class="mvc-guia-holder-trg">{"¿Cuánto dura una Video Consulta?"|x_translate}</a>
                        <div class="mvc-guia-holder">
                            <small class="mvc-bread white">{"Video Consulta/Duración"|x_translate}</small>
                            <figure class="mvc-item-figure-simple">
                                <i class="icon-doctorplus-clock"></i>
                            </figure>
                            <h4 class="mvc-grid-title-3">
                                {"¿Cuánto dura una Video Consulta?"|x_translate}
                            </h4>
                            <p class="mvc-grid-p white">
                                {"Las Video Consultas SIN TURNO o las Publicadas en la Red tienen una duración máxima de 20 minutos."|x_translate}
                                {"Las Video Consultas CON TURNO tienen la misma duración que establezca el médico para sus turnos."|x_translate} 
                                {"Transcurrido dicho plazo las transmisiones finalizan  automáticamente y el profesional dejará registro de sus conclusiones en los Registros Médicos de su Perfil de Salud."|x_translate}</p>
                        </div>
                    </div>

                    <div class="mvc-guia-item mvc-grid-item-11 bg-type-5">
                        <a href="#" class="mvc-guia-holder-trg">{"Requerimientos del sistema"|x_translate}</a>
                        <div class="mvc-guia-holder">
                            <small class="mvc-bread white">{"Video Consulta/Requerimientos"|x_translate}</small>
                            <figure class="mvc-item-figure-simple">
                                <i class="icon-doctorplus-gear-round"></i>
                            </figure>
                            <h4 class="mvc-grid-title-3">
                                {"Requerimientos del sistema."|x_translate}
                            </h4>
                            <p class="mvc-grid-p white">
                                {"Micrófono y Cámara web."|x_translate}
                            </p>
                            <p class="mvc-grid-p white">
                                {"Conexión a internet con Velocidad de subida de 512kbps o superior."|x_translate}
                            </p>
                            <p class="mvc-grid-p white">
                                {"Velocidad de baja 3 Mbps o superior."|x_translate}
                            </p>
                        </div>
                    </div>

                    <div class="mvc-guia-item mvc-grid-item-12 bg-type-3">
                        <a href="#" class="mvc-guia-holder-trg">{"Pagos y reintegros"|x_translate}</a>
                        <div class="mvc-guia-holder">
                            <small class="mvc-bread white">{"Video Consulta/Pagos y reintegros"|x_translate}</small>
                            <figure class="mvc-item-figure-simple">
                                <i class="icon-doctorplus-dollar-circular"></i>
                            </figure>
                            <h4 class="mvc-grid-title-3">
                                {"Pagos y reintegros"|x_translate}
                            </h4>
                            <p class="mvc-grid-p white">
                                {"CONSULTAS POR GUARDIA A PROFESIONALES EN LA RED"|x_translate}
                            </p>
                            <p class="mvc-grid-p white">
                                {"En caso de que su Video Consulta sea respondida por un profesional con tarifa de menor valor, la diferencia le será reembolsada al concluir la consulta."|x_translate} 
                            </p>
                            <p class="mvc-grid-p white">
                                {"Si su solicitud de Video Consulta fue declinada el importe abonado será reembolsado en su cuenta."|x_translate}
                            </p>
                        </div>
                    </div>

                    <div class="mvc-guia-item mvc-grid-item-9 bg-type-2">
                        <a href="#" class="mvc-guia-holder-trg">{"Privacidad y almacenamiento"|x_translate}</a>

                        <div class="mvc-guia-holder">
                            <small class="mvc-bread">{"Video Consulta/Privacidad y almacenamiento"|x_translate}</small>
                            <figure class="mvc-item-figure-img">
                                <img src="{$IMGS}medico/hom-servicios/servicios-slide-1.png" alt="Video Consultas"/>
                            </figure>
                            <p class="mvc-grid-p">
                                {"Las Video Consultas no se graban."|x_translate} 
                                {"Solo se establece una conexión online a través de su cámara web y la del profesional."|x_translate}  
                            </p>
                            <p class="mvc-grid-p">
                                {"Solo quedarán almacenados en su Historia Clínica los mensajes de chat e imágenes enviadas durante el transcurso de la Video Consulta."|x_translate} 
                            </p>
                        </div>
                    </div>

                    <div class="mvc-guia-item mvc-grid-item-7 bg-type-6">
                        <a href="#" class="mvc-guia-holder-trg">{"Video Consultas declinadas"|x_translate}</a>
                        <div class="mvc-guia-holder">
                            <small class="mvc-bread">{"Video Consulta/Declinadas"|x_translate}</small>
                            <figure class="mvc-item-figure">
                                <i class="fas fa-user-times"></i>
                            </figure>
                            <h4 class="mvc-grid-title-2">
                                {"DECLINADAS"|x_translate}
                            </h4>
                            <p class="mvc-grid-p">
                                {"Si su solicitud fuese declinada porque por algún motivo el profesional no pudiese atenderlo (Por ej.  El médico considera que ud. necesita trasladarse a una guardia; necesita revisarlo en forma personal en su consultorio, o se encuentra de vacaciones, etc.)"|x_translate}<br>
                                {"El importe abonado por la Video Consulta que fuese declinada será reintegrado en su cuenta inmediatamente."|x_translate} 
                            </p>
                        </div>
                    </div>

                    <div class="mvc-guia-item mvc-grid-item-8 bg-type-6">
                        <a href="#" class="mvc-guia-holder-trg">{"Video Consultas vencidas"|x_translate}</a>
                        <div class="mvc-guia-holder">
                            <small class="mvc-bread">{"Video Consulta/Vencidas"|x_translate}</small>
                            <figure class="mvc-item-figure">
                                <i class="far fa-calendar-times"></i>
                            </figure>
                            <h4 class="mvc-grid-title-2">
                                {"VENCIDAS"|x_translate}
                            </h4>
                            <p class="mvc-grid-p">
                                {"Video Consultas cuyo plazo de respuesta ha vencido o el paciente decidió cancelar."|x_translate}
                                {"El importe abonado por las Video Consultas vencidas será reintegrado en su cuenta inmediatamente."|x_translate}
                            </p>

                        </div>
                    </div>

                    <div class="mvc-guia-item mvc-grid-item-2 bg-type-6">

                        <a href="#" class="mvc-guia-holder-trg">{"Video Consultas Publicadas en la Red"|x_translate}</a>
                        <div class="mvc-guia-holder">
                            <small class="mvc-bread">{"Video Consulta/Publicadas en la Red"|x_translate}</small>
                            <figure class="mvc-item-figure red">
                                <i class="icon-doctorplus-cam-rss"></i>							
                            </figure>
                            <h4 class="mvc-grid-title-2">
                                {"PUBLICADAS EN LA RED"|x_translate}<br>
                                <small class="mvc-grid-sub-title-1">{"Consultas SIN TURNO"|x_translate}</small>
                            </h4>
                            <p class="mvc-grid-p">
                                {"Las Video Consultas en la Red son sin turno y son enviadas a todos los médicos de la misma especialidad que ud. requiere."|x_translate}
                            </p>
                            <p class="mvc-grid-p">
                                {"Lo atenderá el primer profesional que se desocupe."|x_translate}
                            </p>
                            <p class="mvc-grid-p">
                                {"¡De esta manera su tiempo de espera será mucho menor y será atendido en forma más inmediata!"|x_translate}
                            </p>
                        </div>
                    </div>

                    <div class="mvc-guia-item mvc-grid-item-4 bg-type-6">
                        <a href="#" class="mvc-guia-holder-trg">{"¿Cómo ingresar a la sala?"|x_translate}</a>
                        <div class="mvc-guia-holder">
                            <small class="mvc-bread">{"Video Consulta/Ingreso a la sala"|x_translate}</small>
                            <div class="mvc-grid-circle-holder">
                                <figure class="mvc-item-figure">
                                    <i class="icon-doctorplus-photo"></i>
                                </figure>
                                <figure class="mvc-item-upper-figure">
                                    <i class="icon-doctorplus-video-cam"></i>
                                </figure>
                            </div>

                            <h4 class="mvc-grid-title-2">{"INGRESO A LA SALA"|x_translate}</h4>
                            <p class="mvc-grid-p">
                                {"A la hora acordada entre a la sala del consultorio virtual y espere a que el médico inicie la Video Consulta!"|x_translate}
                            </p>
                            <p class="mvc-grid-p">
                                {"A la sala sólo tendrán acceso 2 usuarios: 1 médico  (único) y 1 paciente (único)."|x_translate}
                            </p>
                            <div class="mvc-grid-cam-disclaimer">
                                <figure class="mvc-grid-cam-disclaimer-figure">
                                    <i class="icon-doctorplus-video-cam"></i>
                                </figure>
                                <figure class="mvc-grid-cam-disclaimer-text">
                                    <p>
                                        {"Indicador de Video Consulta con transmisión en curso"|x_translate}
                                    </p>
                                    <span></span>								
                                </figure>
                            </div>
                        </div>
                    </div>

                </div>

            </div>
        </div>
    </article>
    <article>
        <a href="javascript:;" class="gdu-action-box">
            <h3>{"Enviar consultas a varios medicos"|x_translate}</h3>
        </a>
        <div class="okm-container consulta-distancia gdu-content">
            <div class="okm-row">
                <h4>{"Consulta inmediatamente a varios especialistas en forma simultánea a través de Profesionales en la Red. Te atenderá el primer profesional que se encuentre disponible minimizando tu tiempo de espera."|x_translate}</h4>
                <div class="okm-row">
                    <div class="col-xs-12 text-center">


                        <img class="img-responsive" src="{$IMGS}paciente/usuariologeado/doctorplus-net.png" style="margin:auto;">

                    </div>
                </div>

            </div>
        </div>
    </article>


</section>	





<script type="text/javascript" src="{$url_js_libs}/greensock-js/minified/TweenMax.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}/greensock-js/minified/jquery.gsap.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}/greensock-js/minified/plugins/CSSPlugin.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}/scrollmagic/minified/ScrollMagic.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}/scrollmagic/minified/plugins/jquery.ScrollMagic.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}/scrollmagic/minified/plugins/animation.gsap.min.js"></script>
<script type="text/javascript" src="{$url_js_libs}/scrollmagic/minified/plugins/debug.addIndicators.min.js"></script>
{literal}
    <script type="text/javascript">
        $(document).ready(function () {



            var cta = $('.gdu-action-box');
            var sib = cta.next('div');

            function hideOthers(obj) {
                obj.each(function (i, o) {
                    if ($(this).is(':visible')) {
                        $(this).slideUp();
                    }
                });
            }

            function inicializarCardVideoconsultas() {
                if (getViewportWidth() >= 601) {
                    var $grid = $('.mvc-guia-grid').masonry({
                        columnWidth: '.mvc-grid-sizer',
                        gutter: '.mvc-grid-gutter',
                        itemSelector: '.mvc-guia-item',
                        percentPosition: true
                    });

                } else if (getViewportWidth() <= 800) {

                    $('.mvc-guia-holder-trg').on('click', function (e) {
                        e.preventDefault();
                        $(this).siblings('.mvc-guia-holder').slideToggle();
                    });

                }
            }

            cta.on('click', function (e) {
                e.preventDefault();
                hideOthers(sib);
                if (!$(this).next('div').is(':visible')) {
                    $(this).next('div').slideDown(function () {
                        scrollToEl($(this).prev('a'));
                    });
                    if ($(this).next('div').hasClass("init-masonty")) {
                        inicializarCardVideoconsultas();
                    }
                }

            });



        });
    </script>	
{/literal}