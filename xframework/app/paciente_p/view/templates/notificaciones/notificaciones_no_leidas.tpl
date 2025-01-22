
{include file="notificaciones/notificaciones_acciones.tpl"}

<div id="notificaciones-container" class="notificaciones-pacientes notificaciones-container">

    {foreach from=$listado_notificaciones.rows item=notificacion}

        {if $notificacion.tipoNotificacion_idtipoNotificacion == "1"}
            {include file="notificaciones/item-notificacion-renovacion-receta.tpl"}
        {elseif $notificacion.tipoNotificacion_idtipoNotificacion == "6"}
            {include file="notificaciones/item-notificacion-chequeo.tpl"}

        {elseif $notificacion.tipoNotificacion_idtipoNotificacion == "3"}
            {include file="notificaciones/item-notificacion-turno.tpl"}
        {elseif $notificacion.notificacionSistema_idnotificacionSistema != "" || $notificacion.tipoNotificacion_idtipoNotificacion == "5" || $notificacion.tipoNotificacion_idtipoNotificacion == "7" || $notificacion.tipoNotificacion_idtipoNotificacion == "8"}
            {include file="notificaciones/item-notificacion-info-sistema.tpl"}
        {/if}
    {foreachelse}
        <div class="sin-registros">
            <img src="{$IMGS}icons/icon-sin-notificaciones.png" height="73" width="65" alt="">
            <br /><br />
            <p>{"Ud. no tiene notificaciones"|x_translate}</p>
        </div>
        <!-- /info -->
    {/foreach}
    {if $listado_notificaciones.rows && $listado_notificaciones.rows|@count > 0}
        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="notificaciones"  submodulo="notificaciones_no_leidas" container_id="div_notificaciones_list"}
    {/if}


</div>
