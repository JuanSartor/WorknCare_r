
{include file="notificaciones/notificaciones_acciones.tpl"}

<div id="notificaciones-container" class="notificaciones-pacientes notificaciones-container">

    {foreach from=$listado_notificaciones.rows item=notificacion}

        {include file="notificaciones/item-notificacion-info-sistema.tpl"}
    {foreachelse}
        <div class="sin-registros">
            <img src="{$IMGS}icons/icon-sin-notificaciones.png" height="73" width="65" alt="">
            <h6>{"¡La sección está vacía!"|x_translate}</h6>
            <p>{"Aquí se muestran las notificaciones de Información de promociones y otras comunicaciones que DoctorPlus tiene para Ud."|x_translate}</p>
        </div>	
        <!-- /info -->
    {/foreach}
    {if $listado_notificaciones.rows && $listado_notificaciones.rows|@count > 0}
        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="notificaciones"    submodulo="notificaciones_info_sistema"     container_id="div_notificaciones_list"}
    {/if}


</div>


