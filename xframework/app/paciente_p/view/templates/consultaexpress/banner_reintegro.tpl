<div class="alerta-reintegro">
    {if  $paciente.animal!=1}
        <!-- banner alerta reintegro-->
        {if  ($paciente.pais_idpais==1 && $ConsultaExpress.tipo_consulta=="0" && $especialidad.tipo==1 &&  $filtro.pais_idpais==1) ||($paciente.pais_idpais==1 && $ConsultaExpress.tipo_consulta=="1" && $especialidades_medico.0.tipo==1 && $medico.pais_idpais==1)}
            <div class="row" >
                <div class="ce-nc-p3-disclaimer" style="padding: 24px;">
                    <p class="text-center" style="color: #283e73;">{"Está consultando por cuenta particular."|x_translate}</p>
                    <p class="text-center" style="color: #283e73;">{"Si quiere beneficiar de un reintegro de la Consulta Express, tiene que consultar con sus médicos frecuentes."|x_translate}</p>
                </div>
            </div>
        {else}
            <div class="row" >
                <div class="ce-nc-p3-disclaimer" style="padding: 24px;">
                    <p class="text-center" style="color: #283e73;">{"Está consultando por cuenta particular."|x_translate}</p>
                </div>
            </div>
        {/if} 
    {else}
        <!-- banner mascota-->
        <div class="row" >
            <div class="ce-nc-p3-disclaimer" style="padding: 24px;">
                <p class="text-center" style="color: #283e73;">{"La consulta de su mascota es por cuenta particular y no se beneficia de reintegro"|x_translate}</p>
            </div>
        </div>
    {/if}
</div>