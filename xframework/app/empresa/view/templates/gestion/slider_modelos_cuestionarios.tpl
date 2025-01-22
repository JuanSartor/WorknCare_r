<style>
    .figure-new {
        background-color: #ffffff; 
        text-align: center;
        height: 140px !important;
        padding: 15px;
        margin-right: 20px;
        margin-left: 20px;
        border-radius: 10px;
        border-color: #ffffff;; 
        border: outset #f3f3f3;
        box-shadow: 5px 5px 5px #c7c7c7;
        font-weight: 600;
    }
    .btn-slider-familia{
        background: #EF9C73 !important;
        margin-top: 20px;
        height: 40px;
        width: 180px;
        line-height: 1;
    }
    .btn-slider-familia:hover {
        background: #e9b8a0 !important;
    }
    .div-circulo{
        background: #70ad70;
        height: 35px;
        width: 35px;
        border-radius: 50%;
        color: white;
        line-height: 1.8;
        position: relative;
        left: 290px;
        top: -10px;
    }
    @media (max-width: 700px){
        .div-circulo{
            left: 230px;
        }
    }

</style>


{if $list_cuestionarios && $list_cuestionarios|@count>"0"}

    <!-- Medicos frecuentes-->
    <div id="div_listado_medicos_frecuentes" class="relative">
        {*<div class="pcuh-divider"></div>*}

        <section class="container pul-profesionales-frecuentes" style="top: -30px; position: relative;">

            <div class="pcuh-row pcuh-user-row">

                <div class="pcuh-perfil-salud pcuh-profesionales-frecuentes-card"  style="padding-right: 0px;">
                    <div class="pcuh-profesionales-frecuentes">

                        <div class="pcuh-pf-slide-holder">
                            <div class="okm-row pcuh-pf-slide-box cotainer-slider-medicos-frecuentes">
                                <a href="javascript:;" style="top:-20px;" class="pcuh-pf-slide-control left slider-control-medicos-frecuentes"><i class="icon-doctorplus-left-arrow"></i></a>
                                <div class="pcuh-pf-slide">

                                    {for $i=0 to $list_cuestionarios|@count }
                                        {assign var=familia_cuest value=$list_cuestionarios[$i]}

                                        {if $familia_cuest.id_familia_cuestionario!=""}
                                            <figure class="figure-new">
                                                <div class="div-circulo">{$familia_cuest.cantidad}</div>
                                                <span style="position: relative; top: -20px;">{if $TRADUCCION_DEFAULT=="fr"}  {$familia_cuest.nombre} {else} {$familia_cuest.nombre_en} {/if} </span>
                                                <div class="okm-row text-center" style="top: -20px;">
                                                    <a  href="{$url}entreprises/questionnairelist/{$familia_cuest.id_familia_cuestionario}.html" class="btn btn-default btn-slider-familia">{"Ver"|x_translate}</a>

                                                </div>
                                            </figure>


                                        {/if}

                                    {/for}

                                </div>
                                <a href="javascript:;" style="top:-20px;" class="pcuh-pf-slide-control right slider-control-medicos-frecuentes"><i class="icon-doctorplus-right-arrow"></i></a>
                            </div>


                        </div>

                    </div>
                </div>

            </div>
        </section>
    </div>
{/if}
{literal}
    <script>
        $(function () {
            //seleccion elemento previo - marcamos como activo
            $('.pcuh-pf-slide-control.left,.pcuh-pf-slide-control.right').on('click', function (e) {
                e.preventDefault();
            });

            $('.pcuh-pf-slide').slick({
                //centerMode: true,
                dots: false,
                draggable: true,
                focusOnSelect: true,
                infinite: true,
                speed: 250,
                nextArrow: '.pcuh-pf-slide-control.right',
                prevArrow: '.pcuh-pf-slide-control.left',
                slidesToScroll: 1,
                slidesToShow: 3,
                responsive: [
                    {
                        breakpoint: 990,
                        settings: {slidesToShow: 3, slidesToScroll: 1, centerMode: true}
                    },
                    {
                        breakpoint: 740,
                        settings: {slidesToShow: 2, slidesToScroll: 1, centerMode: false}
                    },
                    {
                        breakpoint: 720,
                        settings: {slidesToShow: 2, slidesToScroll: 1, centerMode: false}
                    },
                    {
                        breakpoint: 600,
                        settings: {slidesToShow: 1, slidesToScroll: 1, centerMode: false, autoplay: true, speed: 1000}
                    }
                ]
            });
            // On before slide change
            $('.pcuh-pf-slide').on('afterChange', function (event, slick, currentSlide, nextSlide) {
                if ($(".select_prof_frecuente").length >= 3) {
                    if ($(".select_prof_frecuente[aria-hidden=false]").length >= 3) {
                        $(".select_prof_frecuente[aria-hidden=false]:eq(1)").trigger("click");
                    } else {
                        $(".select_prof_frecuente[aria-hidden=false]:first").trigger("click");
                    }

                } else {
                    $(".select_prof_frecuente:first").trigger("click");
                }
            });

            var spfItems = $('.pcuh-pf-slide-item');

            function spfDisable(items) {
                items.each(function (index) {

                    $(this).removeAttr('selected');

                    if ($(this).hasClass('active')) {
                        $(this).toggleClass('active');
                    }
                    if (!$(this).hasClass('disabled')) {
                        $(this).toggleClass('disabled');
                    }
                });
            }

            spfItems.on('click', function (e) {
                e.preventDefault();
                spfDisable(spfItems);

                if ($(this).hasClass('disabled')) {
                    $(this).removeClass('disabled');
                }
                $(this).addClass('active');
                $(this).attr('selected', 1);

            });


            //seleccionamos el central
            if ($(".select_prof_frecuente").length >= 3) {
                $(".select_prof_frecuente:eq(1)").trigger("click");
            } else {
                $(".select_prof_frecuente:first").trigger("click");
            }


        });
    </script>
{/literal}
