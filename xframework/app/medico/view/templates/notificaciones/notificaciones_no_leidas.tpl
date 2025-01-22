{include file="notificaciones/notificaciones_acciones.tpl"}

<div id="notificaciones-container" class="notificaciones-container notificaciones-medicos">

    {foreach from=$listado_notificaciones.rows item=notificacion}

        {if $notificacion.tipoNotificacion_idtipoNotificacion == "1"}
            {include file="notificaciones/item-notificacion-renovacion-receta.tpl"}
        {elseif $notificacion.tipoNotificacion_idtipoNotificacion == "2"}
            {include file="notificaciones/item-notificacion-mensaje.tpl"}
            <!-- turno -->
        {elseif $notificacion.tipoNotificacion_idtipoNotificacion == "3"}
            {include file="notificaciones/item-notificacion-turno.tpl"}

        {elseif $notificacion.notificacionSistema_idnotificacionSistema != "" || $notificacion.tipoNotificacion_idtipoNotificacion == "4" || $notificacion.tipoNotificacion_idtipoNotificacion == "5"}
            {include file="notificaciones/item-notificacion-info-sistema.tpl"}
        {/if}
    {foreachelse}
        <div class="sin-registros">
            <img src="{$IMGS}icons/icon-sin-notificaciones.png" height="73" width="65" alt="">
            <br /><br />
            <p>{"Ud. no tiene notificaciones"|x_translate}</p>
        </div>
    {/foreach}
    <!-- /info -->

    {if $listado_notificaciones.rows && $listado_notificaciones.rows|@count > 0}
        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="notificaciones" submodulo="notificaciones_no_leidas" container_id="div_notificaciones_list"}
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

            $(".fecha_inicio_class")
                    .datetimepicker({
                        pickTime: false,
                        language: 'fr'
                    });

            $(".fecha_fin_class")
                    .datetimepicker({
                        pickTime: false,
                        language: 'fr'
                    });

        });


    </script>
{/literal}