<link href="{$url}xframework/app/themes/dp02/css/banner_pass_esante.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />
{if $listado_banner_activos|count >0}
    <section  class="banner-pass-bienetre descuentos-section">
        <div class="okm-container"  > 
            <div class='wrapper'>
                <div class="carousel-wrapper" style="width: 100%">      
                    <div class="carousel-container" style="width: 100%">
                        <a href="javascript:;" class="pcuh-pf-slide-control left pcuh-banner-promociones"><i class="icon-doctorplus-left-arrow"></i></a>

                        <div class="titulo-banner"> <span> {"Nuestros Favoritos"|x_translate}   <i class="fa fa-heart icon-corazon"></i> </span> </div>
                        <div class="carousel-banner"   data-speed="3000" >

                            {foreach from=$listado_banner_activos item=banner}
                                <a href="{if $banner.url!=""}{$banner.url}{else}javascript:;{/if}" target="_blank">
                                    <div class="carousel-item" data-url="{$banner.url}" style=" background-image: url('{$url}xframework/files/entities/banner_promocion/{$banner.idbanner_promocion}/banner.png?{$banner.last_mod}')" >
                                        <div class="footer-banner-promocion">
                                            <h6 class="ver-cod-descuento" data-id="{$banner.idbanner_promocion}">
                                                {if $banner.codigo_descuento!=""}
                                                    {"Ver el codigo de descuento"|x_translate}
                                                {else}
                                                    {"Acceder a la promoción gratuita"|x_translate}
                                                {/if}
                                            </h6>
                                            <div  class="codigo-descuento" data-id="{$banner.idbanner_promocion}" style="display:none;">

                                                {if $banner.codigo_descuento !=""}
                                                    {if  $paciente.is_paciente_empresa=="1" }
                                                        <h5>
                                                            {$banner.codigo_descuento}
                                                        </h5>
                                                    {else}
                                                        <h6>
                                                            {"Reservado para beneficiarios."|x_translate}
                                                        </h6>
                                                    {/if}
                                                {else}
                                                    <h6>
                                                        {"Promoción gratuita"|x_translate}
                                                    </h6>
                                                {/if}

                                            </div>
                                        </div> 
                                    </div>
                                </a>
                            {/foreach}

                        </div>
                        <a href="javascript:;" class="pcuh-pf-slide-control right pcuh-banner-promociones"><i class="icon-doctorplus-right-arrow"></i></a>
                    </div>

                </div>

            </div>
            <div class="clearfix">&nbsp;</div>
    </section>
{/if}
{literal}

    <script type="text/javascript">
        $(document).ready(function () {
            if ($(window).width() <= 800) {
                var qtySlides = 1;
                //ocultamos las flechas si no hay suficiente cantidad de cards para slider
                if ($(".descuentos-section .carousel-item").length <= 1) {
                    $(".pcuh-banner-promociones").remove();
                }
            } else {
                var qtySlides = 3;
                //ocultamos las flechas si no hay suficiente cantidad de cards para slider
                if ($(".descuentos-section .carousel-item").length <= 3) {
                    $(".pcuh-banner-promociones").remove();
                }
            }

            let speed = 3000;
            $('.carousel-banner').slick({
                centerMode: false,
                dots: false,
                draggable: true,
                focusOnSelect: false,
                infinite: true,
                autoplay: true,
                nextArrow: '.pcuh-banner-promociones.pcuh-pf-slide-control.right',
                prevArrow: '.pcuh-banner-promociones.pcuh-pf-slide-control.left',
                autoplaySpeed: speed,
                mobileFirst: true,
                slidesToScroll: 1,
                slidesToShow: qtySlides,

            });

            $('.ver-cod-descuento').on('click', function (e) {
                e.preventDefault();
                e.stopPropagation();
                if ($(this).data('id') != '') {

                    $(".ver-cod-descuento[data-id=" + $(this).data('id') + "]").slideUp("slow");

                    $(".codigo-descuento[data-id=" + $(this).data('id') + "]").show();
                    //  $('.slick-slider').slick('slickPause');
                }

            });



        }
        );

    </script>

{/literal}