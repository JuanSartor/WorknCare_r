{include file="notificaciones/notificaciones_acciones.tpl"}

<div id="notificaciones-container" class="notificaciones-container notificaciones-medicos">

    {foreach from=$listado_notificaciones.rows item=notificacion}

        {include file="notificaciones/item-notificacion-turno.tpl"}
    {foreachelse}
        <div class="sin-registros">
            <img src="{$IMGS}icons/icon-sin-notificaciones.png" height="73" width="65" alt="">
            <h6>{"¡La sección está vacía!"|x_translate}</h6>
            <p>{"Aquí se muestran las notificaciones de TURNOS CANCELADOS y PENDIENTES DE CONFIRMACIÓN."|x_translate} {"Ud. podrá confirmar los turnos solicitados. DoctorPlus se encargá de dar aviso."|x_translate} </p>
        </div>
    {/foreach}
    <!-- /info -->

    {if $listado_notificaciones.rows && $listado_notificaciones.rows|@count > 0}
        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="notificaciones"  submodulo="notificaciones_turnos"  container_id="div_notificaciones_list"}
    {/if}
</div>
