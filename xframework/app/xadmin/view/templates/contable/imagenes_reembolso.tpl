<style>
    @media(min-width:601px){
        .pcuh-pf-slide-actions{
            display: flex;
            justify-content: center;
        }

        .pcuh-pf-slide-actions a   {
            display: inline-block;
            max-width:160px;
            min-width:130px;
        }
    }
    .pcuh-profesionales-frecuentes-card .slick-track{
        margin:auto
    }
    .pcuh-pf-slide-actions a  span {
        display: block;
        font-size: 12px;

    }
    .pcuh-pf-slide-actions a figure{
        margin-bottom: 10px;
    }

    @media(max-width:600px){
        .pcuh-pf-slide-item figure img {
            width: 80px;
        }
        .pcuh-pf-slide-actions {
            display:block;
            padding: 12px 0px;
        }
        .pcuh-pf-slide-actions a {
            display: flex ;
            align-items: center;
            padding: 8px 12px;
            border-radius: 8px;
            background-color: #00A79D;
            color: #fff;
            margin-bottom: 10px;

        }

        .pcuh-pf-slide-actions a span {
            display: inline-block;
            font-size: 12px;
        }
        .pcuh-pf-slide-actions a figure{
            display: inline-block;
            width: 56px;
            background-color: transparent;
            line-height: 1;
            padding:0;
            font-size: 20px;
            margin-bottom: 0px;
        } 
        .pcuh-pf-slide-actions a figure i {
            display: inline;
        }

    }
    .footer-form-reembolso{
        margin-top: 140px!important;
    }
</style>

<link rel="stylesheet" type="text/css" href="{$url}xframework/app/themes/dp02/css/main.css?v={$smarty.now|date_format:"%j"}" />
<link rel="stylesheet" type="text/css" href="{$url}xframework/app/themes/dp02/slick/slick.css?v={$smarty.now|date_format:"%j"}" />
<link rel="stylesheet" type="text/css" href="{$url}xframework/core/libs/libs_js/slick/slick.css?v={$smarty.now|date_format:"%j"}" />
<link rel="stylesheet" type="text/css" href="{$url}xframework/app/themes/dp02/slick/slick.css?v={$smarty.now|date_format:"%j"}" />

<script src="{$url}xframework/core/libs/libs_js/slick/slick.js"></script>

{if $list_imagenes && $list_imagenes|@count>"0"}

    <div id="div_listado_medicos_frecuentes" class="relative" style="height: 150px;">

        <section class="container pul-profesionales-frecuentes" style="margin-top: -40px;">
            <div class="pcuh-row pcuh-user-row">
                <div class="pcuh-perfil-salud pcuh-profesionales-frecuentes-card"  style="padding-right: 0px;">
                    <div class="pcuh-profesionales-frecuentes">

                        <div class="pcuh-pf-slide-holder">
                            <div class="okm-row pcuh-pf-slide-box cotainer-slider-medicos-frecuentes">
                                <a href="javascript:;" class="pcuh-pf-slide-control left slider-control-medicos-frecuentes" style="left:-165px; top:200px; height: 50px;"><i class="icon-doctorplus-left-arrow"></i></a>
                                <div class="pcuh-pf-slide">

                                    {for $i=0 to $list_imagenes|@count -1 }
                                        {assign var=imagen_reembolso value=$list_imagenes[$i]}
                                        {if $imagen_reembolso.ext == 'pdf'}
                                            <iframe src="xframework/files/entities/archivos_reembolso_beneficiario/{$imagen_reembolso.idarchivosReembolsosBeneficiario}/{$imagen_reembolso.nombre}.{$imagen_reembolso.ext}" style="width:600px; height:300px;" frameborder="0"></iframe>
                                            {else}
                                            <img src="xframework/files/entities/archivos_reembolso_beneficiario/{$imagen_reembolso.idarchivosReembolsosBeneficiario}/{$imagen_reembolso.nombre}.{$imagen_reembolso.ext}" style="width:600px; height:300px;">
                                        {/if}
                                    {/for}

                                </div>
                                <a href="javascript:;" class="pcuh-pf-slide-control right slider-control-medicos-frecuentes" style="right:-150px; top:200px; height: 50px;"><i class="icon-doctorplus-right-arrow"></i></a>
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
                slidesToShow: 1
            });
            // On before slide change
            $('.pcuh-pf-slide').on('afterChange', function (event, slick, currentSlide, nextSlide) {

                $(".select_prof_frecuente:first").trigger("click");

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


            });


            $('[data-toggle="tooltip"]').tooltip();


            $(".select_prof_frecuente:first").trigger("click");


        });
    </script>
{/literal}
