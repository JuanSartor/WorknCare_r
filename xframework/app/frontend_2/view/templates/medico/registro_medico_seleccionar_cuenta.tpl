{include file="medico/menu.tpl"}

{include file="home/login.tpl"}




<section class="account-order hom-planes hom-planes-registros" >
    <div class="container">
        <h1 id="hom-planes" class="text-center">{"Planes y tipos de cuentas"|x_translate}</h1>
        <h2 class="text-center">{"Los planes más convenientes de acuerdo a sus necesidades"|x_translate}</h2>
        <div class="row">
            <div class="col-md-4">
                <img src="{$IMGS}graphic-computer.svg" alt="Tipos de cuenta">
            </div>
            <div class="col-md-7">
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
                                <span>{"finales/MES"|x_translate}</span>
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
                    <td>Envío de consejos médicos</td>
                    <td><span class="check"></span></td>
                    <td><span class="check"></span></td>
                </tr>
                <tr>
                    <td>{"50 Pacientes con servicio de CE bonificados"|x_translate}</td>
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
            </small>			
        </div>
    </div>
</section>


{include file="home/contactenos.tpl"}	

<section class="okm-container hom-soporte">
    <h4 id="hom-soporte">{"Soporte"|x_translate}</h4>
    <p>{"¿Necesita ayuda?"|x_translate}</p>

    <div class="hom-soporte-row">
        <div class="hom-soporte-col-x2">
            <a href="javascript:;" >
                <figure><img width="70" style="border:0px;" id="dc_ImgStatus" src="{$IMGSsupport.png}" /></figure>
                <label>
                    <div>{"Chat en vivo"|x_translate}</div>
                    <span>{"Estamos para ayudarlo"|x_translate}</span>
                </label>

            </a>

        </div>

        <div class="hom-soporte-col-x2">
            <a href="mailto:soporte@workncare.io">
                <figure><i class="icon-doctorplus-envelope"></i></figure>
                <label>
                    <div>{"Escríbanos"|x_translate}</div>
                    <span>{"soporte@workncare.io"|x_translate}</span>
                </label>
            </a>
        </div>
    </div>
</section>

{literal}
    <script>

        $(function () {
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

            $('.hslide').on("click", function (e) {
                e.preventDefault();
                //scrollToObj($('#srv-slide-0'));
                var slideNumer = $(this).data('slide');
                $('.hom-servicios-slide').slick('slickGoTo', slideNumer);
            });


            $('.hom-slide').on('init', function (event, slide) {
                $('.hom-slide').find('.slick-dots').find('button').on('click', function (e) {
                    slide.slickSetOption('autoplay', false);
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
            $('.hom-slide').on('swipe', function (event, slide, direction) {
                slide.slickSetOption('autoplay', false);
            });

            $('#hom-nav-rsp-trg').on('click', function (e) {
                e.preventDefault();

                $('#hom-nav-rsp-get').toggleClass('menu-show');

            });

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

        });
    </script>
{/literal}