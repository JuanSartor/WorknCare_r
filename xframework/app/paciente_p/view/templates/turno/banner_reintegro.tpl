{if $paciente.is_paciente_empresa!="1"}
    <!-- Banner alerta reintegro-->
    {if $medico.pais_idpais==1 && $medico.mis_especialidades.0.tipo==1 && (($paciente.titular==1 && $paciente.pais_idpais==1 && ($medico.medico_cabecera==1 || ($medico.medico_cabecera==0 &&$medico.mis_especialidades.0.acceso_directo==1 ))) || ($paciente.titular==0 && $account.paciente.pais_idpais==1)) }
        <div class="okm-row text-center" id="div_reintegro_checked" {if $turno.beneficia_reintegro==1}style="display:block;"{else}style="display:none;"{/if}>
            <h7>{"Esta consulta es elegible al reintegro por la caja y su cubertura privada."|x_translate}</h7>  
            <h7>{"Le pedimos que adelante el precio de la consulta para permitir a su médico verificar sus derechos. Cuando ese mismo los valide y envie el reporte de consulta a la caja, recibira una notificacion y se acreditara el importe adelantado en su cuenta."|x_translate}</h7>  
        </div>

        <div class="okm-row text-center" id="div_reintegro_unchecked" {if $turno.beneficia_reintegro==1}style="display:none;"{else}style="display:block;"{/if}>
            <h7>{"Esta consulta NO es elegible al reintegro por la caja y su cubertura privada. Necesita confirmar el criterio siguiente para eso"|x_translate}</h7>  
        </div>

        <div class="okm-row  text-center">
            <label class="checkbox beneficia_reintegro">
                <input type="checkbox" id="beneficia_reintegro" {if $turno.beneficia_reintegro==1}checked{/if}  data-toggle="radio" class="custom-radio">
                {if $paciente.beneficia_ald==1}
                    {"Confirmo que he tenido una consulta presencial en los últimos 12 meses y que el especialista está incluido en mi protocolo de tratamiento"|x_translate}
                {else}
                    {"Confirmo que he tenido una consulta presencial en los últimos 12 meses"|x_translate}
                {/if}
            </label>
        </div>

    {else}

        <div class="okm-row text-center">
            <h7>{"Esta consulta NO es elegible al reintegro por la caja y su cubertura privada."|x_translate}</h7>  
        </div>

    {/if}
{/if}