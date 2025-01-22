<link href="{$url}xframework/app/themes/dp02/css/home_public.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />

<style>
    #Main {
        height: 100%;
        margin: 0;
        padding: 0;
    }
    .categoria-item{
        opacity: 0;
    }
    .fix-nav2{
        top: 5px !important;
    }
    @media (max-width:600px){
        .fix-nav2{
            top: 4px !important;
        }
    }
</style>
{include file="home/login.tpl"}
<section class="top-section categorias-section">


    <div class="okm-container">
        <nav class="hom-nav2" id="hom-nav2">
            <div id="hom-nav-menu" class="hom-nav-menu">
                <div class="menu-group">
                    <a href="javascript:;" id="hom-nav-rsp-trg" class="hom-nav-burger"><i class="fa fa-bars"></i></a>
                </div>
                <ul id="hom-nav-rsp-get">
                    <li><a href="{$url}creer-un-compte.html" class="uh-top-lnk btn-signup" title='{"Crear cuenta"|x_translate}'>{"Crear una cuenta"|x_translate}</a></li>
                    <li><a href="javascript:;" id="loginbtn" class="uh-top-lnk btn-login" data-toggle="modal" data-target=".login"  title='{"Iniciar sesión"|x_translate}'>{"Iniciar sesión"|x_translate}</a></li>
                </ul>
            </div>
        </nav>
        <div class="home-doctorplus-logo logo-small">
            <a href="{$url}"><img src="{$IMGS}logo_workncare_color.png" title="WorknCare"></a>
        </div>
        <div class="home-main">
            <div class="home-doctorplus-logo">
                <a href="{$url}"><img src="{$IMGS}logo_workncare_color.png" title="WorknCare"></a>
            </div>
        </div>

        <div id="listado_categorias_container">
            <div class="programa-background">
                <a href="{$url}portailsalaries" class="btn-volver-home-sante" ><i class="fa fa-chevron-left"></i>{"Volver"|x_translate}</a>
                <div class="categorias-wrapper"> 
                    <div class="icon-container margen-top-yves-esthetic">
                        {if $programa.icon.original !=""}
                            <img {if $programa.idprograma_salud=="27"}class="img-excepcion-categoria-yves" {/if}
                                                                      {if $programa.idprograma_salud=="28"}class="img-excepcion-categoria-esthetic" {/if}
                                                                      src="{$programa.icon.original}" title="{$programa.programa_salud}" alt="{$programa.programa_salud}" />
                        {/if}
                    </div>
                    <div class="title-holder">
                        {if $programa.idprograma_salud!="27" && $programa.idprograma_salud!="28"}
                            {$programa.programa_salud}
                        {/if}
                    </div>
                    <div class="descripcion-holder">
                        {$programa.descripcion} 
                        {if $programa.descripcion_larga!=""}
                            <button data-type="button" class="descripcion-larga-btn" data-toggle="modal" data-target="#modal_descripcion_larga">{if $programa.propio=="0"} {"Ver más"|x_translate} {else} 
                            {if $programa.idprograma_salud =='54' || $programa.idprograma_salud =='55' || $programa.idprograma_salud =='56' }{"Cómo funciona?"|x_translate}{else}{"Condiciones de reembolso"|x_translate} {/if}       {/if}</button>
                            {/if}
                                {if $programa.propio==1}
                                    {if $programa.url_web!=""}
                                    <br>
                                    <a class="btn btn-ver-mas btn-website" href="{$programa.url_web}" target="_blank"> {"Website"|x_translate} </a>
                                {/if}
                            {/if}
                        </div>
                            <div class="categorias-list" {if    $listado_categorias|count == '1' }style="justify-content: center;" {/if}>
                            {foreach from=$listado_categorias item=categoria}
                                <a class="categoria-item btn-ver-categoria" data-id="{$categoria.idprograma_categoria}"href="{$url}thematique/{$programa.idprograma_salud}-{$programa.programa_salud|str2seo}/{$categoria.idprograma_categoria}-{$categoria.programa_categoria|str2seo}.html" title='{$categoria.programa_categoria}'>

                                    <div {if $categoria.portadas.original !=""} class="categoria-detail image" style="background:url('{$categoria.portadas.original}')"{else}class="categoria-detail"{/if}>

                                        {if $categoria.imagenes.original !=""}
                                            <div class="icon">
                                                <img src="{$categoria.imagenes.original}" title="{$categoria.programa_categoria}" alt=" {$categoria.programa_categoria}" />
                                            </div>
                                        {/if}

                                        <div class="content">
                                            <div class=title>
                                                {$categoria.programa_categoria}
                                            </div>
                                        </div>

                                    </div>
                                </a>
                            {/foreach}
                        </div>
                        {if $programa.url_video!=""}
                            <div class="video-container">
                                <iframe {if $programa.propio == "1"} class="iframe-excepcion" {/if} src="{$programa.url_video}" frameborder="0" controls="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen>
                                </iframe>
                            </div>
                        {/if}
                    </div>
                </div>
            </div>
            {if $programa.descripcion_larga!=""}
                <div id="modal_descripcion_larga" class="modal fade bs-example-modal-lg" tabindex="-1" role="dialog">
                    <div class="modal-dialog modal-lg ubicacion-modal-condiciones" role="document">
                        <div class="modal-content">
                            <span class="close-btn" data-dismiss="modal" aria-label="Close"><i class="fui-cross"></i></span>
                            <div class="descripcion-content">
                                <h6 class="text-center"> {$programa.programa_salud}</h6>
                                {$programa.descripcion_larga}
                            </div>
                        </div>
                    </div>
                </div>
            {/if}
        </div>
    </section>
    <div class="clearfix">&nbsp;</div>
    <script type="text/javascript" src="{$url}xframework/core/libs/libs_js/scrollmagic/minified/TweenMax.min.js"></script>
    <script type="text/javascript" src="{$url}xframework/core/libs/libs_js/scrollmagic/minified/ScrollMagic.min.js"></script>
    <script type="text/javascript" src="{$url}xframework/core/libs/libs_js/scrollmagic/minified/plugins/jquery.ScrollMagic.min.js"></script>
    <script type="text/javascript" src="{$url}xframework/core/libs/libs_js/scrollmagic/minified/plugins/animation.gsap.min.js"></script>
    <script type="text/javascript" src="{$url}xframework/core/libs/libs_js/scrollmagic/minified/plugins/debug.addIndicators.min.js"></script>



    {literal}
        <script>
            $(function () {
                if ($(window).width() <= 600) {
                    $(".categoria-item:lt(2)").css("opacity", 1);
                    $(".categoria-item:gt(1)").addClass("reveal-categoria-item");
                } else {
                    $(".categoria-item:lt(6)").css("opacity", 1);
                    $(".categoria-item:gt(5)").addClass("reveal-categoria-item");
                }

                $('.reveal-categoria-item').each(function (i, e) {
                    $(this).addClass("reveal" + i);
                });
                //animacion aparecer con scroll
                // init controller
                var controller = new ScrollMagic.Controller();
                $('.categoria-item').each(function (i, e) {
                    // create a scene
                    new ScrollMagic.Scene({
                        triggerElement: this, // trigger desencadenador de animacion cuando el scroll llega ahi
                        offset: 220, // start a little later

                        triggerHook: 0.7,
                        reverse: false
                    })
                            .setClassToggle(".reveal" + i, "visible") // agregar clases de animacion
                            //.addIndicators({name: "reveal-categoria-item" + i}) // indicadores de posicion de scroll (requires plugin)
                            .addTo(controller);
                });

            });
        </script>
    {/literal}

    {if (($url=="https://www.workncare.io/")&&($programa.idprograma_salud=="21")) || (($url=="https://test.workncare.io/")&&($programa.idprograma_salud=="21"))}
        {literal}
            <!-- Perfumist Tag Manager -->
            <script>
                var _mtm = window._mtm = window._mtm || [];
                _mtm.push({'mtm.startTime': (new Date().getTime()), 'event': 'mtm.Start'});
                var d = document, g = d.createElement('script'), s = d.getElementsByTagName('script')[0];
                g.async = true;
                g.src = 'https://stats.perfumist.fr/js/container_tXEg1EOE.js';
                s.parentNode.insertBefore(g, s);
            </script>
            <!-- End Perfumist Tag Manager -->
        {/literal}
    {/if}


    {literal}
        <script>

            $(function () {
                $(document).ready(function () {
                    $("#hom-nav2").addClass("fix-nav2");
                    //console.log($(location).attr('href'));
                });


                $('#hom-nav-rsp-trg').on('click', function (e) {

                    $('#hom-nav-menu').toggleClass('menu-show');

                });

            });

        </script>
    {/literal}