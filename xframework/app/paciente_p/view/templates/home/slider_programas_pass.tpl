<link href="{$url}xframework/app/themes/dp02/css/banner_pass_esante.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />
<link href="{$url}xframework/app/themes/dp02/css/slider_programas_pass.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />

<section  class="banner-pass-bienetre programas-section" style="background:#ffffff">
    <div class="okm-container"  > 
        <div class='wrapper'>
            <div class="carousel-wrapper" style="width: 100%">      
                <div class="carousel-container" style="width: 100%">
                    {* {include file="home/teaser_home_paciente.tpl"} *}
                    <!--  <h2>Que peut-on faire pour vous?</h2> -->
                    <div class="carousel-banner-programas"   data-speed="3000" >

                        {foreach from=$listado_grupo_programas item=programa}
                            {if $programa.propio!="1"}
                                <div class="carousel-item item "  style="background-image: url('{$programa.imagen.original}')" >
                                    <div class="programa-destacado-tag" data-id="{$programa.idprograma_salud}">
                                        <span class="content">
                                            {"Gratuita"|x_translate}
                                        </span>
                                    </div>
                                    {foreach from=$recompensas_ganadas item=recompensa}
                                        {if $recompensa.programasalud_idprogramasalud == $programa.idprograma_salud}
                                            <div class="programa-destacado-recompensa-tag" data-id="{$programa.idprograma_salud}">
                                                <span class="content">
                                                    {"Recompensa"|x_translate}
                                                </span>
                                            </div>
                                        {/if}
                                    {/foreach}

                                    <a href="{$url}patient/programmes-bienetre/{$programa.idprograma_salud}-{$programa.programa_salud|str2seo}.html" class="btn-ver-categoria" data-id="{$programa.idprograma_salud}" title='{$programa.programa_salud}'>
                                        <div class="img-container">
                                            <div class="title-holder">
                                                {$programa.programa_salud}
                                            </div>
                                        </div>
                                    </a>
                                </div>
                            {/if}
                        {/foreach}
                    </div>
                    <a href="javascript:;" class="pcuh-pf-slide-control left pcuh-banner-programas flechas-ubicacion slider-control-izquierda"><i class="icon-doctorplus-left-arrow"></i></a>
                    <a href="javascript:;" class="pcuh-pf-slide-control right pcuh-banner-programas flechas-ubicacion slider-control-derecha"><i class="icon-doctorplus-right-arrow"></i></a>
                </div>

            </div>

        </div>
        <div class="clearfix">&nbsp;</div>
</section>


<script>
    var ids_excepciones_programa = "{$ids_excepciones_programa}";
</script>
{literal}
    <script>
        $(function () {
            //desmarcamos los programas que no son ofrecidos por la empresa
            if (ids_excepciones_programa !== "") {

                if (ids_excepciones_programa !== "ALL" && ids_excepciones_programa !== "NONE") {
                    ids_excepciones_programa.split(',').forEach(function (id) {
                        $(".programa-destacado-tag[data-id=" + id + "]").addClass("hide");
                    });
                    $(".programa-destacado-tag:not(.hide)").show();
                } else if (ids_excepciones_programa === "ALL") {
                    $(".programa-destacado-tag").show();
                } else {
                    $(".programa-destacado-tag").hide();
                }
            }
        });
    </script>

    <script type="text/javascript">
        $(document).ready(function () {
            if ($(window).width() <= 800) {
                var qtySlides = 3;
                //ocultamos las flechas si no hay suficiente cantidad de cards para slider
                if ($(".programas-section .carousel-item").length <= 1) {
                    $(".pcuh-banner-programas").remove();
                }
            } else {
                var qtySlides = 6;
                //ocultamos las flechas si no hay suficiente cantidad de cards para slider
                if ($(".programas-section .carousel-item").length <= 3) {
                    $(".pcuh-banner-programas").remove();
                }
            }

            let speed = 3000;
            $('.carousel-banner-programas').slick({
                centerMode: false,
                dots: false,
                draggable: true,
                focusOnSelect: false,
                infinite: true,
                autoplay: true,
                nextArrow: '.pcuh-banner-programas.pcuh-pf-slide-control.right',
                prevArrow: '.pcuh-banner-programas.pcuh-pf-slide-control.left',
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
                    $(".codigo-descuento[data-id=" + $(this).data('id') + "]").slideUp("slow");
                    $(".codigo-descuento[data-id=" + $(this).data('id') + "]").show();
                    //  $('.slick-slider').slick('slickPause');
                }

            });



        }
        );

    </script>

{/literal}