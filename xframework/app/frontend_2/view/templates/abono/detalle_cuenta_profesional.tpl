{include file="medico/menu.tpl"}

{include file="home/login.tpl"}



<div class="main-content home">
    <section class="professional account-type container text-center">
        <h1>{"Cuenta Profesional"|x_translate}</h1>
        <h2>{"¡Todas las funcionalidades sin descuentos por comisión!"|x_translate}</h2>
        <div class="row highlights">
            <div class="col-md-3 col-sm-3">
                <figure>
                    <img src="{$IMGS}doctor_phone.jpg" alt="" class="img-responsive" />
                </figure>
                <div class="highlight-box text-center">
                    <div class="price">
                        <span>&euro; {$MONTO_CUOTA}</span>
                        <span>{"finales/MES"|x_translate}</span>
                    </div>

                    <a href="{$url}professionnel/creer-un-compte.html" role="button" title='{"Adquirir cuenta Profesional"|x_translate}'>{"Adquirir"|x_translate}</a>

                </div>
                <p class="disclaimer uppercase"><small>{"Pesos Argentinos"|x_translate}</small></p>
            </div>
            <div class="col-md-8 col-md-offset-1 col-sm-8 col-sm-offset-1 plan-highlights">
                <p class="text-left">
                    {"Ideal para profesionales con alta demanda y requerimiento de sus pacientes fuera del consultorio"|x_translate}
                </p>
                <button class="toggle-features visible-xs">{"Ver Características"|x_translate}</button>
                <div class="row special-features">
                    <div class="col-md-4">
                        <ul>
                            <li><span class="dp-agenda">{"Agenda de Turnos on line"|x_translate}</span></li>
                            <li><span class="dp-alarm">{"Recordatorios de turnos por email"|x_translate}</span></li>
                            <li><span class="dp-sms">{"Recordatorios o cancelaciones de turnos por SMS"|x_translate}</span></li>
                            <li><span class="dp-info">{"Acceso a la Info de Salud de sus pacientes desde cualquier dispositivo"|x_translate}</span></li>
                        </ul>
                    </div>
                    <div class="col-md-4">
                        <ul>
                            <li><span class="dp-express">{"Consulta Express"|x_translate}</span></li>
                            <li><span class="icon-doctorplus-video-call">{"Video Consulta"|x_translate}</span></li>
                            <li><span class="dp-support">{"Soporte Técnico por chat y email"|x_translate}</span></li>
                            <li><span class="dp-stats">{"Registro de sus consultas médicas a distancia"|x_translate}</li>
                        </ul>
                    </div>
                </div>
            </div>
    </section>
</div>

<section class="professional features">
    <div class="container">
        <h3 class="text-center">{"Funcionalidades que le encantarán"|x_translate}</h3>
        <div id="app-features" class="carousel slide" data-ride="carousel">
            <!-- Indicators -->
            <ol class="carousel-indicators icon-indicators">
                <li class="dp-express active" data-target="#app-features" data-slide-to="0" ></li>
                <li class="dp-video" data-target="#app-features" data-slide-to="1"></li>
                <li class="dp-stats" data-target="#app-features" data-slide-to="2"></li>
                <li class="dp-alarm" data-target="#app-features" data-slide-to="3"></li>
                <li class="dp-info" data-target="#app-features" data-slide-to="4"></li>
            </ol>

            <!-- Wrapper for slides -->
            <div class="carousel-inner" role="listbox">
                <div class="item active">
                    <div class="row">
                        <div class="col-sm-3 col-sm-offset-2 col-xs-12">
                            <img class="img-responsive" src="{$IMGS}doctor_smartphone.png" title='{"Consulta Express"|x_translate}'>
                        </div>
                        <div class="col-sm-6 col-xs-12">
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
                        <div class="col-sm-3 col-sm-offset-2 col-xs-12">
                            <img class="img-responsive" src="{$IMGS}doctor_smartphone.png" title='{"Consulta Express"|x_translate}'>
                        </div>
                        <div class="col-sm-6 col-xs-12">
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
                        <div class="col-sm-3 col-sm-offset-2 col-xs-12">
                            <img class="img-responsive" src="{$IMGS}graphic-stats.svg" title='{"Estadísticas de sus Consultas"|x_translate}'>
                        </div>
                        <div class="col-sm-6 col-xs-12">
                            <div class="content-wrapper">
                                <h4 class="slide-title">{"Estadísticas de sus Consultas"|x_translate}</h4>
                                <p>
                                    {"Sepa qué prepagas son las más utilizadas."|x_translate}
                                    {"Reportes de sus turnos, estadísticas de ausentismo, qué pacientes han faltado a su consulta, etc."|x_translate}
                                </p>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="item">
                    <div class="row">
                        <div class="col-sm-3 col-sm-offset-2 col-xs-12">
                            <img class="img-responsive" src="{$IMGS}graphic-envelope.svg" title='{"Recordatorio de turnos"|x_translate}'>
                        </div>
                        <div class="col-sm-6 col-xs-12">
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
                        <div class="col-sm-3 col-sm-offset-2 col-xs-12">
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
                <h3>{"Envíe confirmaciones y recordatorios de turnos por SMS  a sus pacientes"|x_translate}</h3>
                <p>
                    {"Una de las principales causas de ausentismo de pacientes es el olvido de su turno médico."|x_translate}<br />
                    {"Mediante el envío automático de recordatorios de turnos por SMS, los pacientes recibirán una notificación de DoctorPlus en su celular horas antes de su turno disminuyendo asi la tasa de ausentismo en su consultorio."|x_translate}
                </p>
            </div>
        </div>
    </div>
</section>

<section class="order">
    <div class="container text-center">
        <h5>{"Todo incluido, por un PRECIO inmejorable"|x_translate}</h5>

        <div class="account-type pro">
            <div>
                <span>{"Cuenta Profesional"|x_translate}</span>
                <span class="price">&euro;{$MONTO_CUOTA}<span>{"finales / MES"|x_translate}</span></span>
            </div>
        </div>

        <p class="disclaimer text-center uppercase">{"PRECIOS EXPRESADOS EN PESOS ARGENTINOS"|x_translate}</p>
        <a href="{$url}professionnel/creer-un-compte.html" class="uppercase next small" role="button" title='{"Adquirir cuenta Profesional"|x_translate}'>{"ADQUIRIR"|x_translate}</a>
    </div>
</section>




{literal}
<script>



    $(function() {


        //formulario envio mail conactto
        $("#btnEnviarMailContacto").click(function(e) {

            e.preventDefault();
            // Clean up any tooltips for valid elements


            $("#f_contacto input:required").each(function() {
                if ($(this).val() == "") {
                    $(this).data("title", x_translate("Este campo es obligatorio"))
                            .tooltip("show");
                }
                return false;
            });

            if ($("#f_contacto textarea").val() == "") {
                $("#f_contacto textarea").data("title", x_translate("Este campo es obligatorio"))
                        .tooltip("show");

            }

            //expresion regular para mail
            if (!validarEmail($("#email_contacto").val())) {
                $("#email_contacto").data("title", x_translate("Ingrese un email valido"))
                        .tooltip("show");
                return false;
            }


            $("#Main").spin("large");
            x_sendForm(
                    $('#f_contacto'),
                    true,
                    function(data) {
                        $("#Main").spin(false);
                        x_alert(data.msg);
                    });
        });



        function mulScroll(trgObj) {
            var trgObjHeight = trgObj.outerHeight();
            $('html, body').animate({
                scrollTop: (trgObj.offset().top - trgObjHeight) - 60
            }, 1000);
        }



        $('.hom-servicios-slide').slick({
            dots: false,
            infinite: true,
            speed: 300,
            arrows: false,
            autoplay: true,
            autoplaySpeed: 8000,
            adaptiveHeight: true
        });

        $('.hslide').on("click", function(e) {
            e.preventDefault();
            //scrollToObj($('#srv-slide-0'));
            var slideNumer = $(this).data('slide');
            $('.hom-servicios-slide').slick('slickGoTo', slideNumer);
        });


		$('.hom-slide').on('init', function(event, slide){
			$('.hom-slide').find('.slick-dots').find('button').on('click',function(e){
						slide.slickSetOption('autoplay',false);
			});
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
			pauseOnDotsHover: true,
			adaptiveHeight: true
		});
		$('.hom-slide').on('swipe',function(event, slide, direction){
			slide.slickSetOption('autoplay',false);
		});

        $('#hom-nav-rsp-trg').on('click', function(e) {
            e.preventDefault();

            $('#hom-nav-rsp-get').toggleClass('menu-show');

        });

        $(window).on('scroll', function() {
            var currentTop = $(window).scrollTop();

            if (currentTop >= 60) {
                $('.hom-nav').addClass('transparent');
            } else if (currentTop < 60) {
                $('.hom-nav').removeClass('transparent');
            }

        });

        var menuEl = $('#hom-nav-rsp-get').children('li').children('a');

        menuEl.on('click', function(e) {
            e.preventDefault();

            if (typeof $(this).data('lnk') !== 'undefined') {
                var lnkTo = "#" + $(this).data('lnk');
                mulScroll($(lnkTo));
            }


            if ($('#hom-nav-rsp-get').hasClass('menu-show')) {
                $('#hom-nav-rsp-get').removeClass('menu-show');
            }

        });


    });
</script>
{/literal}