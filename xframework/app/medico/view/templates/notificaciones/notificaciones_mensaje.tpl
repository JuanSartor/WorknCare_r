{include file="notificaciones/notificaciones_acciones.tpl"}

<div id="notificaciones-container" class="notificaciones-container notificaciones-medicos">

    {foreach from=$listado_notificaciones.rows item=notificacion}
        {include file="notificaciones/item-notificacion-mensaje.tpl"}
    {foreachelse}
        <div class="sin-registros">
            <img src="{$IMGS}icons/icon-sin-notificaciones.png" height="73" width="65" alt="">
            <h6>{"¡La sección está vacía!"|x_translate}</h6>
            <p>{"Aquí se muestran las notificaciones de Mensajes recibidos de otros profesionales"|x_translate} <br>{"de Doctorplus que desean compartir contenidos y opiniones."|x_translate} </p>
        </div>
    {/foreach}
    <!-- /info -->

    {if $listado_notificaciones.rows && $listado_notificaciones.rows|@count > 0}
        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="notificaciones"   submodulo="notificaciones_mensaje"     container_id="div_notificaciones_list"}
    {/if}
</div>


{literal}
    <script>
        $(document).ready(function () {
            $('.gallery').featherlightGallery({
                gallery: {fadeIn: 300, fadeOut: 300}
            });

            $.featherlightGallery.prototype.afterContent = function () {
                var caption = this.$currentTarget.find('img').attr('alt');
                this.$instance.find('.caption').remove();
                $('<div class="caption">').text(caption).appendTo(this.$instance.find('.featherlight-content'));
            };

        });

    </script>
{/literal}