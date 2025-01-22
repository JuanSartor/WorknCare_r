<link href="{$url}xframework/app/themes/dp02/css/home_public.css?v={$smarty.now|date_format:"%j"}" rel="stylesheet" type="text/css" />
<style>
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

<input type="hidden" id="idprograma_categoria" value={$smarty.request.idprograma_categoria}>
<div class="listado_medicos_wrapper top-section profesionales-section">
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

        <div class="home-doctorplus-logo logo-small profesionales-section">
            <a href="{$url}"><img src="{$IMGS}logo_workncare_color.png" title="WorknCare"></a>
        </div>
        <div class="home-main profesionales-section">
            <div class="home-doctorplus-logo">
                <a href="{$url}"><img src="{$IMGS}logo_workncare_color.png" title="WorknCare"></a>
            </div>
        </div>
        <a href="{$url}thematique/{$programa.idprograma_salud}-{$programa.programa_salud|str2seo}.html" class="btn-volver-home-sante" data-id="{$programa.idprograma_salud}"><i class="fa fa-chevron-left"></i>{"Volver"|x_translate}</a>

        <div class="listado_medicos_container">

            <div class="title-holder">
                <div class="icon">
                    {if $categoria.imagenes.original !=""}
                        <img src="{$categoria.imagen.original}" title="{$categoria.programa_categoria}" alt=" {$categoria.programa_categoria}" />
                    {/if}
                </div>

                <h1 class="title">
                    {$categoria.programa_categoria}
                </h1>
            </div>
            <div class="categoria-detail">

                <div class="descripcion-holder">
                    <div class="descripcion">
                        {$categoria.descripcion}
                        {if $categoria.url_video!=""}
                            <!-- aca normalmente en las empresas que no son de dp, ingresan un link de direccion
                            para redireccionar, el video esta por debajo-->
                            <a class="btn btn-ver-mas" href="{$categoria.url_video}" target="_blank">{if $programa.propio=="0"} {"Ver más"|x_translate} {else} {"Acceder"|x_translate}{/if}</a>
                        {/if}
                        {if $programa.propio==1}
                            {if $categoria.url_video_inferior!=""}
                                <br>
                                <br>
                                <iframe width="100%" height="310"  src="{$categoria.url_video_inferior}" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
                                {/if}

                            {if $categoria.ilustracion.original !=""}
                                <div class="icon" style="text-align: center;">
                                    <img src="{$categoria.ilustracion.original}" class="ilustracion-categoria" title="{$categoria.programa_categoria}" alt=" {$categoria.programa_categoria}" />
                                </div>
                            {/if}
                        {/if}
                    </div>


                </div>
            </div>

            <div class="medicos-listado-resultado">
                <div id="modulo_listado_consultorios" class="relative">


                </div>
            </div>
        </div>
    </div>
    {include file="busqueda/busqueda_profesional_mapa.tpl"}
    {if $programa.propio!="1"}
        {include file="busqueda/como_funciona.tpl" }
    {/if}
</div>

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
{x_load_js}