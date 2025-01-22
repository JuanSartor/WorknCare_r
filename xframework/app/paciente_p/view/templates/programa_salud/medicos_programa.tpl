<input type="hidden" id="idprograma_categoria" value={$smarty.request.idprograma_categoria}>
<div class="listado_medicos_wrapper">
    <a href="{$url}patient/programmes-bienetre/{$programa.idprograma_salud}-{$programa.programa_salud|str2seo}.html" class="btn-volver-home-sante" data-id="{$programa.idprograma_salud}"><i class="fa fa-chevron-left"></i>{"Volver"|x_translate}</a>

    <div class="title-holder">
        <div class="icon">
            {if $categoria.imagenes.original !=""}
                <img src="{$categoria.imagen.original}" title="{$categoria.programa_categoria}" alt=" {$categoria.programa_categoria}" />
            {/if}
        </div>

        <h1 class=title>
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
                            <img class="ilustracion-categoria" src="{$categoria.ilustracion.original}" title="{$categoria.programa_categoria}" alt=" {$categoria.programa_categoria}" />
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
    {include file="busqueda/busqueda_profesional_mapa.tpl"}
    {if $programa.propio!="1"}
        {include file="busqueda/como_funciona.tpl" }
    {/if}

</div>
{x_load_js}