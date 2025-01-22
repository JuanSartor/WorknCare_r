{include file="notificaciones/notificaciones_acciones.tpl"}


<div id="notificaciones-container" class="notificaciones-container notificaciones-medicos">

    {foreach from=$listado_notificaciones.rows item=notificacion}

        {include file="notificaciones/item-notificacion-renovacion-receta.tpl"}
    {foreachelse}
        <div class="sin-registros">
            <img src="{$IMGS}icons/icon-sin-notificaciones.png" height="73" width="65" alt="">
            <p>{"Aquí se muestran las notificaciones de RENOVACIÓN DE RECETA solicitadas por sus pacientes"|x_translate} <br>
                {"Ud. podrá confirmarlas o rechazarlas según corresponda y Doctorplus se encargará de enviarle un aviso a su paciente"|x_translate}</p>
        </div>
    {/foreach}
    <!-- /info -->

    {if $listado_notificaciones.rows && $listado_notificaciones.rows|@count > 0}
        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="notificaciones"    submodulo="notificaciones_renovacion_receta"     container_id="div_notificaciones_list"}
    {/if}
</div>


{literal}
    <script>
        $(document).ready(function () {

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