<section class="okm-container mmc-detale-consulta">
    <h1 class="mmc-title">{$nombre_mes} {$periodo_pago.anio}</h1>
    <div class="mmc-detalle-consulta-box">
        <div class="okm-row">

            <div class="mmc-detalle-consulta-col">
                <i class="icon-doctorplus-chat"></i>
                <div class="mmc-cant-consultas">{if $periodo_pago}{$periodo_pago.total_consulta_express}{else}0{/if}</div>
                <a href="#" class="resumen-trg-ce mmc-detalle-consulta-btn">{"ver detalle de consultas"|x_translate}</a>
                <div class="mmc-price">&euro; {if $periodo_pago.importe_consulta_express!=""}{$periodo_pago.importe_consulta_express}{else}0{/if}</div>
                <div class="mmc-price-comision">
                    {"Comisión DoctorPlus"|x_translate}
                    <span>-&euro; {if $periodo_pago.importe_comision_consulta_express!=""}{$periodo_pago.importe_comision_consulta_express}{else}0{/if}</span>
                </div>
            </div>

            <div class="mmc-detalle-consulta-col">
                <i class="icon-doctorplus-video-call"></i>
                <div class="mmc-cant-consultas">{if $periodo_pago}{$periodo_pago.total_videoconsulta}{else}0{/if}</div>
                <a href="#" class="resumen-trg-vc mmc-detalle-consulta-btn">{"ver detalle de consultas"|x_translate}</a>
                <div class="mmc-price">&euro; {if $periodo_pago.importe_videoconsulta!=""}{$periodo_pago.importe_videoconsulta}{else}0{/if}</div>
                <div class="mmc-price-comision">
                    {"Comisión DoctorPlus"|x_translate}
                    <span>-&euro; {if $periodo_pago.importe_comision_videoconsulta!=""}{$periodo_pago.importe_comision_videoconsulta}{else}0{/if}</span>
                </div>
            </div>

        </div>
    </div>

    <div class="mmc-price-total">
        {* <i class="icon-doctorplus-dollar-circular"></i> *}
        <span>{"Total del período"|x_translate}</span>
        <span class="mmc-price">&euro; {if $periodo_pago.importePeriodo!=""}{$periodo_pago.importePeriodo}{else}0{/if}</span>
    </div>

</section>

{include file="cuenta/solicitar_pago.tpl"}
<div id="div_resumen_consultaexpress"></div>
<div id="div_resumen_videoconsulta"></div>
<script>
    x_loadModule('cuenta', 'resumen_consultaexpress', 'do_reset=1&idperiodoPago={$idperiodoPago}', 'div_resumen_consultaexpress', BASE_PATH + "medico");
    x_loadModule('cuenta', 'resumen_videoconsulta', 'do_reset=1&idperiodoPago={$idperiodoPago}', 'div_resumen_videoconsulta', BASE_PATH + "medico");
</script>


