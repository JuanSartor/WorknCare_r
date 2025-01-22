<link href="{$url}xframework/app/themes/dp02/css/banner_pass_esante.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />
<link href="{$url}xframework/app/themes/dp02/css/slider_programas_pass.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />
<!-- seccion del boton y logo empresa socia -->
{if $empresaCompleta.image!= '' }
    <div class="row fila-btn-iconoempresa"> 
        <div class="col-action alinear-action-div">
            <a id="infomacion-modal"  href="{$url}panel-paciente/"  class="btn boton  btn-modal-inicio">{"Informacion"|x_translate}</a>           
        </div> 
        <img  class="icono-socia" src="{$empresaCompleta.image.usuario}?t={$smarty.now}">
    </div>
{else}
    <div class="col-action alinear-action-div">
        <a id="infomacion-modal"  href="{$url}panel-paciente/"  class="btn boton  btn-modal-inicio">{"Informacion"|x_translate}</a>           
    </div> 
{/if}
<!-- fin seccion boton y logo empresa socia -->

<section  class="banner-pass-bienetre programas-section" style="background:#ffffff">
    <div class="okm-container"  > 
        <div class='wrapper'>
            <div class="carousel-wrapper" style="width: 100%;     margin-top: 20px;">      
                <div class="carousel-container" style="width: 100%">
                    {include file="home/teaser_home_paciente.tpl"}
                    <!-- <h2>Que peut-on faire pour vous?</h2> -->
                    <div class="carousel-banner-programas-socios"   data-speed="3000" >

                        {foreach from=$listado_grupo_programas_socios item=programa}
                            {if $programa.propio=="1"}
                                <div class="carousel-item item "  style="background-image: url('{$programa.imagen.original}')" >
                                    <div class="programa-destacado-tag programa-destacado-reembolso-tag" data-id="{$programa.idprograma_salud}">
                                        <span class="content">
                                            {"Reembolsar"|x_translate}
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
                    <a href="javascript:;" class="pcuh-pf-slide-control left pcuh-banner-programas-socios flechas-ubicacion slider-control-izquierda"><i class="icon-doctorplus-left-arrow"></i></a>
                    <a href="javascript:;" class="pcuh-pf-slide-control right pcuh-banner-programas-socios flechas-ubicacion slider-control-derecha"><i class="icon-doctorplus-right-arrow"></i></a>
                </div>

            </div>

        </div>

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
                    $(".pcuh-banner-programas-socios").remove();
                }
            } else {
                var qtySlides = 6;
                //ocultamos las flechas si no hay suficiente cantidad de cards para slider
                if ($(".programas-section .carousel-item").length <= 3) {
                    $(".pcuh-banner-programas-socios").remove();
                }
            }

            let speed = 3000;
            $('.carousel-banner-programas-socios').slick({
                centerMode: false,
                dots: false,
                draggable: true,
                focusOnSelect: false,
                infinite: true,
                autoplay: true,
                nextArrow: '.pcuh-banner-programas-socios.pcuh-pf-slide-control.right',
                prevArrow: '.pcuh-banner-programas-socios.pcuh-pf-slide-control.left',
                autoplaySpeed: speed,
                mobileFirst: true,
                slidesToScroll: 1,
                slidesToShow: qtySlides,

            });





        }
        );

        $("#infomacion-modal").click(function () {
            x_doAjaxCall(
                    'POST',
                    BASE_PATH + 'paciente_p.php?action=1&modulo=home&submodulo=actualizar_modal_sesion',
                    function () {
                    }
            );
        });

    </script>

{/literal}