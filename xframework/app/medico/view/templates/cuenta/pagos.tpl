<section class="table-detail">
    <div class="container">
        <div class="table-reference">
            <h2>{"Solicitudes de pagos"|x_translate}</h2>
            <div class="reference pull-right">
                <span class="status-ok">{"Pagado"|x_translate}</span>
                <span class="status-progress">{"En proceso"|x_translate}</span>
                <span class="status-stop">{"Rechazado"|x_translate}</span>
            </div>
        </div>
        <table class="table table-responsive">
                        
            <tr>
                <th>{"Período"|x_translate}</th>
                <th>{"Fecha solicitud"|x_translate}</th>
                <th>{"Total del período"|x_translate}</th>
                <th>{"Comisión DoctorPlus"|x_translate}</th>
                <th>{"Comprobante"|x_translate}</th>
                <th>{"Fecha de pago"|x_translate} </th>
                <th>{"Estado de pago"|x_translate}</th>
            </tr>
            
            {foreach from=$list_medico_pagos.rows item=pago}
            <tr>
                <td>{$pago.periodo_format}</td>
                <td>{$pago.fechaSolicitudPago|date_format:"%d/%m/%Y"}</td>
                <td>&euro; {$pago.importePeriodo}</td>
                <td>&euro; {$pago.importe_comisiones}</td>
                <td> {if $pago.posee_file=="1"}<a href="{$url}factura-comisiones.do?hash={$pago.hash}" target='_blank' class="mul-comprobante"><i class="icon-doctorplus-sheet"></i></a>{/if}</td>
                <td>{if $pago.fechaPago!=""}{$pago.fechaPago|date_format:"%d/%m/%Y"}{else}-{/if}</td>
                <td>
                    {if $pago.estado == 1}
                    <span class="status-ok"></span>
                    {elseif $pago.estado == 0}
                    <span class="status-progress"></span>
                    {else}
                    <span class="status-stop"></span>
                    {/if}
                </td>
            </tr>
            {foreachelse}
            <tr>
                <td colspan="7">
                    {"No posee solicitudes de pago pendientes"|x_translate}
                </td>
            </tr>
            {/foreach}
           
        </table>
          <div class="okm-row">
                <div class="col-xs-12">
                    
                    {if $list_medico_pagos.rows && $list_medico_pagos.rows|@count > 0}
                    <div class="paginas">
                        {x_paginate_loadmodule_v2  id="$idpaginate" modulo="cuenta"
                        submodulo="pagos" 
                        container_id="cont_periodo"}
                    </div>
                    {/if}
                    
                </div>
            </div>
    </div>
</section>