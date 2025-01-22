<section id="resumen_periodo_consultaexpress" class="mmc-resumen-periodo" style="display:none;">
    <div class="mmc-resumen-top">
        <div class="okm-container mmc-resumen-top-in">
            <h2>{"Resumen Consultas Express del Período"|x_translate}</h2>
            <div class="mmc-resumen-download-box">
                <a href="{$url}panel-medico/mi-cuenta/{$idperiodoPago}-resumen-periodo-{$nombre_mes}-{$periodo_pago.anio}.pdf" target="_blank" data-toggle="tooltip" data-placement="left" title='{"Descargar período"|x_translate}'><i class="icon-doctorplus-bandeja-in"></i></a>
            </div>
        </div>
    </div>

    <div class="okm-container okm-row mmc-resumen-list-box">
        {if $resumen_consultaexpress.rows && $resumen_consultaexpress.rows|@count > 0}


            <ul class="mmc-resumen-list-1">
                {foreach from=$resumen_consultaexpress.rows item=consultaexpress name=foo}
                    {if $smarty.foreach.foo.iteration%2==1}
                        <li>
                            <span>{$consultaexpress.fecha_fin_format}  -  {$consultaexpress.paciente.nombre} {$consultaexpress.paciente.apellido}{if $consultaexpress.prestador!=""} ({$consultaexpress.prestador.nombre}){/if}</span>
                            {* <span>{if $consultaexpress.prestador_idprestador!=""}&euro; {$consultaexpress.precio_tarifa_prestador}{else}&euro; {$consultaexpress.precio_tarifa}{/if}</span>*}
                            <span>&euro; {$consultaexpress.precio_tarifa}&nbsp;
                                <a target="_blank" class="btn btn-xs btn-white"  title='{"descargar"|x_translate}' href="{$url}medico.php?action=1&modulo=cuenta&submodulo=resumen_consulta_particular_pdf&id={$consultaexpress.idconsultaExpress}&tipo=ce"><i class="fa fa-file-text-o"></i></a>
                            </span>
                        </li>
                    {/if}
                {/foreach}

            </ul>
            <ul class="mmc-resumen-list-2">
                {foreach from=$resumen_consultaexpress.rows item=consultaexpress name=foo}
                    {if $smarty.foreach.foo.iteration%2==0}
                        <li>
                            <span>{$consultaexpress.fecha_fin_format}  -  {$consultaexpress.paciente.nombre} {$consultaexpress.paciente.apellido}{if $consultaexpress.prestador!=""} ({$consultaexpress.prestador.nombre}){/if}</span>
                            <span>&euro; {$consultaexpress.precio_tarifa}&nbsp;   
                                <a  target="_blank" class="btn btn-xs btn-white"  title='{"descargar"|x_translate}' href="{$url}medico.php?action=1&modulo=cuenta&submodulo=resumen_consulta_particular_pdf&id={$consultaexpress.idconsultaExpress}&tipo=ce"><i class="fa fa-file-text-o"></i></a>
                            </span>  
                        </li>
                    {/if}
                {/foreach}
            </ul>
        {/if}
    </div>
    <div class="okm-row">
        <div class="col-xs-12">

            {if $resumen_consultaexpress.rows && $resumen_consultaexpress.rows|@count > 0}
                <div class="paginas">
                    {x_paginate_loadmodule_v2  id="$idpaginate" modulo="cuenta"
                submodulo="resumen_consultaexpress" 
                container_id="div_resumen_consultaexpress"}
                </div>
            {/if}

        </div>
    </div>
</section>

{literal}
    <script>
        $(function () {
            //botones accion de los desplegables del  resumen consultas express
            $('.resumen-trg-ce').on('click', function (e) {
                e.preventDefault();

                $("#resumen_periodo_consultaexpress").slideDown();
                $("#resumen_periodo_videoconsulta").slideDown();
                scrollToEl($('#resumen_periodo_consultaexpress'));
            });

        });
    </script>
{/literal}
