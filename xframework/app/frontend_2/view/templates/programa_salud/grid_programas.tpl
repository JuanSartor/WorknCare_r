<style>
    .group-container{
        opacity: 0;
    }
</style>
<div class="background">
    <div class="wrapper okm-container">
        {** <div class="okm-row text-center section-title ">
        <h2 class="pc-visible">Que peut-on faire pour vous?</h2>
        <h2 class="mobile-visible"><span>Que peut-on faire</span><span>pour vous?</span></h2>
        </div> **}
        <br>
        {foreach from=$listado_grupo_programas item=grupo}
            <div class="group-container group-color-child">
                <div class="group-title">
                    <h3> {if $TRADUCCION_IDIOMA=="fr"}{$grupo.nombre} {else}{$grupo.nombre_en} {/if} <img class="emoji" src="{$url}xframework/app/themes/dp02/img/emojis/{$grupo.idprograma_salud_grupo}.png"></h3>

                </div>
                <div class="group-item-list showing">
                    {foreach from=$grupo.listado_programas item=programa}
                        <div class="item {if count($grupo.listado_programas) == 3 || count($grupo.listado_programas) == 2 || count($grupo.listado_programas) == 1} un-programa {/if}" style="background-image: url('{$programa.imagen.original}')" >
                            <a href="{$url}thematique/{$programa.idprograma_salud}-{$programa.programa_salud|str2seo}.html" class="btn-ver-categoria" data-id="{$programa.idprograma_salud}" title='{$programa.programa_salud}'> 
                                <div class="img-container">
                                    <div class="title-holder">
                                        {$programa.programa_salud}
                                    </div>
                                </div>
                            </a>
                        </div>

                    {/foreach}

                </div>
            </div>
        {/foreach}
    </div>

</div>
<div class="clearfix"></div>
<script type="text/javascript" src="{$url}xframework/core/libs/libs_js/scrollmagic/minified/TweenMax.min.js"></script>
<script type="text/javascript" src="{$url}xframework/core/libs/libs_js/scrollmagic/minified/ScrollMagic.min.js"></script>
<script type="text/javascript" src="{$url}xframework/core/libs/libs_js/scrollmagic/minified/plugins/jquery.ScrollMagic.min.js"></script>
<script type="text/javascript" src="{$url}xframework/core/libs/libs_js/scrollmagic/minified/plugins/animation.gsap.min.js"></script>
<script type="text/javascript" src="{$url}xframework/core/libs/libs_js/scrollmagic/minified/plugins/debug.addIndicators.min.js"></script>

{literal}
    <script>
        $(function () {
            //agrergamos una clase para mostrar en mobile la ultima card en ancho total
            $(".group-container").each(function (i, e) {

                let qty = $(e).find(".item").length;
                //si es impar al ultimo agregamos clase para que ocupe todo el ancho    
                if (qty % 2 == 1) {
                    $(e).find(".item:first").addClass("last-odd");
                }
            });
            //marcamos los contanedores que deben aparecer con animacion - primero visible
            $(".group-container:lt(1)").css("opacity", 1);
            $(".group-container:gt(0)").addClass("reveal-grupo-categorias");


            $('.reveal-grupo-categorias').each(function (i, e) {
                $(this).addClass("reveal" + i);
            });
            //animacion aparecer con scroll
            // init controller
            var controller = new ScrollMagic.Controller();
            $('.reveal-grupo-categorias').each(function (i, e) {
                // create a scene
                new ScrollMagic.Scene({
                    triggerElement: this, // trigger desencadenador de animacion cuando el scroll llega ahi
                    offset: -100, // start a little later

                    triggerHook: 0.7,
                    reverse: false
                })
                        .setClassToggle(".reveal" + i, "visible") // agregar clases de animacion
                        //.addIndicators({name: "reveal-grupo-categorias" + i}) // indicadores de posicion de scroll (requires plugin)
                        .addTo(controller);
            });

        });
    </script>
{/literal}